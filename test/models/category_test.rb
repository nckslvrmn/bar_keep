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

  test "validates name uniqueness regardless of case" do
    Category.create!(name: "Whiskey")
    duplicate = Category.new(name: "whiskey")
    assert_not duplicate.valid?
  end

  test "find_or_create_by_name matches an existing category ignoring case" do
    existing = Category.create!(name: "Whiskey")

    assert_no_difference "Category.count" do
      assert_equal existing, Category.find_or_create_by_name("whiskey")
      assert_equal existing, Category.find_or_create_by_name("  WHISKEY  ")
    end
  end

  test "find_or_create_by_name creates a category that does not exist yet" do
    assert_difference "Category.count", 1 do
      category = Category.find_or_create_by_name("Amaro")
      assert_equal "Amaro", category.name
      assert_equal "amaro", category.slug
    end
  end

  test "find_or_create_by_name handles names with no sluggable characters" do
    first = Category.find_or_create_by_name("!!!")

    assert_no_difference "Category.count" do
      assert_equal first, Category.find_or_create_by_name("!!!")
    end
  end

  test "delete_orphaned removes categories with no items" do
    orphan = Category.create!(name: "Orphan")
    attached = Category.create!(name: "Attached")
    items(:bourbon).categories << attached

    Category.delete_orphaned

    assert_not Category.exists?(orphan.id)
    assert Category.exists?(attached.id)
  end
end
