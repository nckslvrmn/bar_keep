require "test_helper"

class GuestAccessTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:guest)
  end

  test "guest can view all items" do
    get items_path
    assert_response :success
    # Guest sees all users' items
    assert_match "Buffalo Trace", response.body
    assert_match "Admin Whiskey", response.body
  end

  test "guest can view item details" do
    get item_path(items(:bourbon))
    assert_response :success
  end

  test "guest cannot create items" do
    get new_item_path
    assert_redirected_to items_path
    assert_match "read-only", flash[:alert]
  end

  test "guest cannot edit items" do
    get edit_item_path(items(:bourbon))
    assert_redirected_to items_path
  end

  test "guest cannot delete items" do
    assert_no_difference "Item.count" do
      delete item_path(items(:bourbon))
    end
    assert_redirected_to items_path
  end

  test "guest cannot increment quantity" do
    original = items(:bourbon).quantity
    patch increment_item_path(items(:bourbon))
    assert_equal original, items(:bourbon).reload.quantity
  end

  test "guest cannot access admin panel" do
    get admin_users_path
    assert_redirected_to root_path
  end
end
