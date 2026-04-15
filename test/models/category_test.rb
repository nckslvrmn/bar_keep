require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "validates name presence" do
    category = Category.new
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "validates name uniqueness" do
    Category.create!(name: "Unique Cat")
    duplicate = Category.new(name: "Unique Cat")
    assert_not duplicate.valid?
  end

  test "generates slug from name" do
    category = Category.create!(name: "Dark Spirits")
    assert_equal "dark-spirits", category.slug
  end
end
