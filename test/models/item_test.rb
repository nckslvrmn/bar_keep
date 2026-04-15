require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "validates name presence" do
    item = Item.new(quantity: 1, item_type: "Alcohol", user: users(:regular))
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "validates quantity presence and non-negative" do
    item = Item.new(name: "Test", item_type: "Alcohol", user: users(:regular))
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
    assert_equal ["Mixers", "Spirits"], names
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

  test "scope by_type filters by item type" do
    results = Item.by_type("Syrup")
    assert_includes results, items(:low_stock_syrup)
    assert_not_includes results, items(:bourbon)
  end
end
