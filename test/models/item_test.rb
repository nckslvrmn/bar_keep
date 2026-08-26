require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "validates name presence" do
    item = Item.new(quantity: 1, item_type: "Alcohol", user: users(:regular))
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "validates quantity presence and non-negative" do
    item = Item.new(name: "Test", item_type: "Alcohol", user: users(:regular))
    item.quantity = nil
    assert_not item.valid?

    item.quantity = -1
    assert_not item.valid?

    item.quantity = 0
    assert item.valid?
  end

  test "validates item_type inclusion" do
    item = Item.new(name: "Test", quantity: 1, item_type: "Invalid", user: users(:regular))
    assert_not item.valid?
    assert_includes item.errors[:item_type], "is not included in the list"
  end

  test "out_of_stock? returns true when quantity is zero" do
    assert items(:out_of_stock_gin).out_of_stock?
    assert_not items(:bourbon).out_of_stock?
  end

  test "low_stock? returns true when quantity is at or below threshold" do
    assert items(:low_stock_syrup).low_stock?
    assert_not items(:bourbon).low_stock?
    assert_not items(:out_of_stock_gin).low_stock? # out of stock is not low stock
  end

  test "needs_restocking? returns true for out of stock or low stock" do
    assert items(:out_of_stock_gin).needs_restocking?
    assert items(:low_stock_syrup).needs_restocking?
    assert_not items(:bourbon).needs_restocking?
  end

  test "increment_quantity! increases quantity" do
    item = items(:bourbon)
    original = item.quantity
    item.increment_quantity!(2)
    assert_equal original + 2, item.reload.quantity
  end

  test "increment_quantity! ignores a negative amount" do
    item = items(:bourbon)
    original = item.quantity
    item.increment_quantity!(-99)
    assert_equal original + 1, item.reload.quantity
  end

  test "decrement_quantity! ignores a negative amount" do
    item = items(:bourbon)
    original = item.quantity
    item.decrement_quantity!(-99)
    assert_equal original - 1, item.reload.quantity
  end

  test "quantity adjustments do not lose concurrent writes" do
    item = items(:bourbon)
    item.update!(quantity: 0)
    stale = Item.find(item.id)

    item.increment_quantity!(1)
    stale.increment_quantity!(1)

    assert_equal 2, item.reload.quantity
  end

  test "quantity adjustments touch updated_at" do
    item = items(:bourbon)
    item.update!(updated_at: 1.day.ago)

    assert_changes -> { item.reload.updated_at } do
      item.increment_quantity!
    end
  end

  test "decrement_quantity! decreases quantity but not below zero" do
    item = items(:bourbon)
    item.decrement_quantity!(1)
    assert_equal 2, item.reload.quantity

    item.update!(quantity: 1)
    item.decrement_quantity!(5)
    assert_equal 0, item.reload.quantity
  end

  test "metadata_hash returns key-value pairs" do
    item = items(:bourbon)
    hash = item.metadata_hash
    assert_equal "Total Wine", hash["purchase_location"]
    assert_equal "$29.99", hash["price"]
  end

  test "update_metadata replaces all metadata" do
    item = items(:bourbon)
    item.update_metadata({ "brand" => "BT", "origin" => "Kentucky" })
    item.reload

    assert_equal 2, item.item_metadata.count
    assert_equal "BT", item.metadata_hash["brand"]
    assert_nil item.metadata_hash["purchase_location"] # old key gone
  end

  test "update_metadata keeps rows that survive the update" do
    item = items(:bourbon)
    item.update_metadata({ "brand" => "BT" })
    row = item.item_metadata.find_by(key: "brand")

    item.update_metadata({ "brand" => "Buffalo Trace", "origin" => "Kentucky" })
    updated = item.item_metadata.find_by(key: "brand")

    assert_equal row.id, updated.id
    assert_equal row.created_at.to_i, updated.created_at.to_i
    assert_equal "Buffalo Trace", updated.value
  end

  test "update_metadata clears everything when given nothing" do
    item = items(:bourbon)
    item.update_metadata({ "brand" => "BT" })
    item.update_metadata({})

    assert_empty item.item_metadata
  end

  test "update_metadata accepts controller parameters" do
    item = items(:bourbon)
    item.update_metadata(ActionController::Parameters.new(brand: "BT", empty: ""))

    assert_equal "BT", item.metadata_hash["brand"]
    assert_nil item.metadata_hash["empty"]
  end

  test "update_metadata skips blank values" do
    item = items(:bourbon)
    item.update_metadata({ "brand" => "BT", "empty" => "" })
    assert_equal 1, item.item_metadata.reload.count
  end

  test "category_names returns comma-separated names" do
    item = items(:bourbon)
    item.categories << categories(:spirits)
    item.categories << categories(:mixers)
    names = item.category_names.split(", ").sort
    assert_equal [ "Mixers", "Spirits" ], names
  end

  test "scope out_of_stock returns only zero-quantity items" do
    results = Item.out_of_stock
    assert results.all? { |i| i.quantity == 0 }
    assert_includes results, items(:out_of_stock_gin)
  end

  test "scope search filters by name" do
    results = Item.search("Buffalo")
    assert_includes results, items(:bourbon)
    assert_not_includes results, items(:out_of_stock_gin)
  end

  test "scope search treats LIKE wildcards as literal characters" do
    literal = users(:regular).items.create!(name: "10% Off Rum", quantity: 1, item_type: "Alcohol")
    decoy = users(:regular).items.create!(name: "100 Proof Rum", quantity: 1, item_type: "Alcohol")

    results = Item.search("10%")
    assert_includes results, literal
    assert_not_includes results, decoy
  end

  test "scope by_type filters by item type" do
    results = Item.by_type("Syrup")
    assert_includes results, items(:low_stock_syrup)
    assert_not_includes results, items(:bourbon)
  end
end
