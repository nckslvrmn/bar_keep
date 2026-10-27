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

  test "reusing a category with different casing does not blow up" do
    item = items(:bourbon)
    patch item_path(item), params: { item: { name: item.name, category_names: "Whiskey" } }
    assert_redirected_to item_path(item)

    assert_no_difference "Category.count" do
      patch item_path(items(:low_stock_syrup)), params: {
        item: { name: items(:low_stock_syrup).name, category_names: "whiskey" }
      }
    end
    assert_redirected_to item_path(items(:low_stock_syrup))
    assert_equal [ "Whiskey" ], items(:low_stock_syrup).reload.categories.map(&:name)
  end

  test "the form offers existing categories as chips" do
    items(:bourbon).categories = [ categories(:spirits) ]

    get new_item_path
    assert_select "[data-controller='category-picker']"
    assert_select "button[data-category-picker-name-param='Spirits']"
    assert_select "input[name='item[category_names]'][data-category-picker-target='field']"
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

  test "image search returns results as json" do
    results = [ { title: "Bottle", thumbnail_url: "https://imgs.search.brave.com/t", image_url: "https://example.com/b.png" } ]

    with_brave_api_key do
      stub_class_method(BraveImageSearch, :search, ->(query) { query == "Buffalo Trace" ? results : [] }) do
        get image_search_items_path, params: { q: "Buffalo Trace" }
      end
    end

    assert_response :success
    assert_equal "https://example.com/b.png", response.parsed_body.first["image_url"]
  end

  test "image search reports upstream failures" do
    with_brave_api_key do
      stub_class_method(BraveImageSearch, :search, ->(_query) { raise BraveImageSearch::Error, "429" }) do
        get image_search_items_path, params: { q: "Buffalo Trace" }
      end
    end

    assert_response :bad_gateway
  end

  test "image search is unavailable without an api key" do
    with_brave_api_key(nil) do
      get image_search_items_path, params: { q: "Buffalo Trace" }
    end

    assert_response :not_found
  end

  test "the form offers image search only when an api key is set" do
    with_brave_api_key do
      get edit_item_path(items(:bourbon))
    end
    assert_select "[data-controller='image-search'] input[data-image-search-target='query']"

    with_brave_api_key(nil) do
      get edit_item_path(items(:bourbon))
    end
    assert_select "[data-controller='image-search']", false
  end

  test "a failed create keeps the submitted metadata" do
    post items_path, params: {
      item: { name: "", quantity: 1, item_type: "Alcohol" },
      metadata: { price: "$42.50", vintage: "1998" }
    }

    assert_response :unprocessable_entity
    assert_select "input[name='metadata[price]'][value='$42.50']"
    assert_select "input[name='metadata[vintage]'][value='1998']"
  end

  test "a failed update keeps the submitted metadata" do
    patch item_path(items(:bourbon)), params: {
      item: { name: "" },
      metadata: { purchase_location: "Costco", price: "$29.99" }
    }

    assert_response :unprocessable_entity
    assert_select "input[name='metadata[purchase_location]'][value='Costco']"
  end

  test "remove image detaches the current image" do
    item = items(:bourbon)
    item.image.attach(io: Rails.root.join("public/icon-192.png").open, filename: "icon.png", content_type: "image/png")

    patch item_path(item), params: { item: { remove_image: "1" } }

    assert_redirected_to item_path(item)
    assert_not item.reload.image.attached?
  end

  test "the edit form offers to remove an attached image" do
    item = items(:bourbon)
    get edit_item_path(item)
    assert_select "input[name='item[remove_image]']", false

    item.image.attach(io: Rails.root.join("public/icon-192.png").open, filename: "icon.png", content_type: "image/png")
    get edit_item_path(item)
    assert_select "input[type='checkbox'][name='item[remove_image]']"
  end
end
