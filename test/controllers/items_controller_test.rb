require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:regular)
  end

  test "index shows user items" do
    get items_path
    assert_response :success
    assert_match "Buffalo Trace", response.body
  end

  test "index requires authentication" do
    delete logout_path
    get items_path
    assert_redirected_to login_path
  end

  test "show displays item details" do
    get item_path(items(:bourbon))
    assert_response :success
    assert_match "Buffalo Trace", response.body
  end

  test "new renders form" do
    get new_item_path
    assert_response :success
  end

  test "create with valid params" do
    assert_difference "Item.count", 1 do
      post items_path, params: {
        item: {
          name: "New Vodka",
          quantity: 2,
          low_stock_threshold: 1,
          item_type: "Alcohol",
          category_names: "Spirits, Vodka"
        }
      }
    end
    assert_redirected_to item_path(Item.last)

    # Verify categories were created
    assert_equal 2, Item.last.categories.count
  end

  test "create with invalid params renders the form with errors" do
    assert_no_difference "Item.count" do
      post items_path, params: {
        item: { name: "", quantity: -1, item_type: "Alcohol" }
      }
    end
    assert_response :unprocessable_entity
    assert_match "prohibited this item from being saved", response.body
  end

  test "a failed create does not leave categories behind" do
    assert_no_difference "Category.count" do
      post items_path, params: {
        item: { name: "", quantity: 1, item_type: "Alcohol", category_names: "Ghost" }
      }
    end
    assert_not Category.exists?(name: "Ghost")
  end

  test "update item" do
    patch item_path(items(:bourbon)), params: {
      item: { name: "Updated Bourbon" }
    }
    assert_redirected_to item_path(items(:bourbon))
    assert_equal "Updated Bourbon", items(:bourbon).reload.name
  end

  test "destroy item" do
    assert_difference "Item.count", -1 do
      delete item_path(items(:bourbon))
    end
    assert_redirected_to items_url
  end

  test "increment quantity" do
    item = items(:bourbon)
    original = item.quantity
    patch increment_item_path(item), params: { amount: 2 }
    assert_equal original + 2, item.reload.quantity
  end

  test "decrement quantity" do
    item = items(:bourbon)
    original = item.quantity
    patch decrement_item_path(item)
    assert_equal original - 1, item.reload.quantity
  end

  test "set_quantity sets an absolute value" do
    item = items(:bourbon)
    patch set_quantity_item_path(item), params: { quantity: 24 }
    assert_equal 24, item.reload.quantity
  end

  test "set_quantity clamps out of range values" do
    item = items(:bourbon)

    patch set_quantity_item_path(item), params: { quantity: -5 }
    assert_equal 0, item.reload.quantity

    patch set_quantity_item_path(item), params: { quantity: 999_999 }
    assert_equal Item::MAX_QUANTITY, item.reload.quantity
  end

  test "set_quantity responds with a turbo stream" do
    patch set_quantity_item_path(items(:bourbon)), params: { quantity: 7 }, as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
  end

  test "the quantity field is editable in place" do
    get items_path
    assert_select "input.quantity-input[name='quantity'][aria-label='Buffalo Trace quantity']"
  end

  test "increment responds with a turbo stream" do
    item = items(:bourbon)
    patch increment_item_path(item), as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_match "turbo-stream", response.body
  end

  test "the quantity stream morphs the row using turbo's native action" do
    item = items(:bourbon)
    patch increment_item_path(item), as: :turbo_stream

    assert_match(/action="replace"/, response.body)
    assert_match(/method="morph"/, response.body)
    assert_match(/target="item_row_#{item.id}"/, response.body)
  end

  test "updating categories removes ones left orphaned" do
    item = items(:bourbon)
    patch item_path(item), params: { item: { name: item.name, category_names: "Rare" } }
    assert Category.exists?(name: "Rare")

    patch item_path(item), params: { item: { name: item.name, category_names: "Common" } }
    assert_not Category.exists?(name: "Rare"), "orphaned category should be deleted"
    assert Category.exists?(name: "Common")
  end

  test "destroying an item cleans up its orphaned categories" do
    item = items(:bourbon)
    patch item_path(item), params: { item: { name: item.name, category_names: "Solo" } }
    assert Category.exists?(name: "Solo")

    delete item_path(item)
    assert_not Category.exists?(name: "Solo"), "orphaned category should be deleted"
  end

  test "cannot access other users items" do
    get item_path(items(:admin_item))
    assert_response :not_found
  end

  test "filters by stock status" do
    get items_path, params: { stock_status: "out_of_stock" }
    assert_response :success
    assert_match "Hendricks Gin", response.body
    assert_no_match "Buffalo Trace", response.body
  end

  test "filters by search" do
    get items_path, params: { search: "Buffalo" }
    assert_response :success
    assert_match "Buffalo Trace", response.body
  end

  test "pages carry their own title" do
    get items_path
    assert_select "title", "Inventory · Bar Keep"

    get item_path(items(:bourbon))
    assert_select "title", "Buffalo Trace · Bar Keep"
  end

  test "flash notice renders after a redirect" do
    patch item_path(items(:bourbon)), params: { item: { name: "Renamed" } }
    follow_redirect!
    assert_match "Item was successfully updated.", response.body
  end
end
