require "test_helper"

class ItemMetadatumTest < ActiveSupport::TestCase
  test "validates key presence" do
    metadata = ItemMetadatum.new(item: items(:bourbon), value: "test")
    assert_not metadata.valid?
    assert_includes metadata.errors[:key], "can't be blank"
  end

  test "validates key uniqueness per item" do
    ItemMetadatum.create!(item: items(:out_of_stock_gin), key: "notes", value: "first")
    duplicate = ItemMetadatum.new(item: items(:out_of_stock_gin), key: "notes", value: "second")
    assert_not duplicate.valid?
  end

  test "allows same key on different items" do
    ItemMetadatum.create!(item: items(:out_of_stock_gin), key: "notes", value: "gin note")
    other = ItemMetadatum.new(item: items(:low_stock_syrup), key: "notes", value: "syrup note")
    assert other.valid?
  end
end
