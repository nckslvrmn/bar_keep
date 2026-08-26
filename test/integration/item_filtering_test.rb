require "test_helper"

class ItemFilteringTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:regular)
    items(:bourbon).categories = [ categories(:spirits) ]
    items(:out_of_stock_gin).categories = [ categories(:spirits), categories(:mixers) ]
    items(:low_stock_syrup).categories = [ categories(:mixers) ]
  end

  test "the results live in a turbo frame that targets the top level" do
    get items_path
    assert_select "turbo-frame#items[target='_top']"
  end

  test "the list offers a row and card view toggle" do
    get items_path
    assert_select "html[data-items-view='rows']"
    assert_select ".view-toggle button[data-view-toggle-view-param='rows']"
    assert_select ".view-toggle button[data-view-toggle-view-param='cards']"
  end

  test "row controls name the item they act on" do
    get items_path
    assert_select "a[aria-label='Edit Buffalo Trace']"
    assert_select "a[aria-label='Delete Buffalo Trace']"
    assert_select "button[aria-label='Add one Buffalo Trace']"
    assert_select "button[aria-label='Remove one Buffalo Trace']"
  end

  test "sorts by name by default" do
    get items_path
    names = css_select(".item-name-cell a").map(&:text)
    assert_equal names.sort, names
  end

  test "sorting by restock puts empty shelves first" do
    get items_path, params: { sort: "restock" }
    names = css_select(".item-name-cell a").map(&:text)
    assert_equal "Hendricks Gin", names.first
    assert_equal "Simple Syrup", names.second
  end

  test "sorting by quantity runs low to high" do
    get items_path, params: { sort: "quantity" }
    names = css_select(".item-name-cell a").map(&:text)
    assert_equal [ "Hendricks Gin", "Simple Syrup", "Buffalo Trace" ], names
  end

  test "an unknown sort falls back to name" do
    get items_path, params: { sort: "'; DROP TABLE items; --" }
    assert_response :success
    names = css_select(".item-name-cell a").map(&:text)
    assert_equal names.sort, names
  end

  test "sort survives a filter change" do
    get items_path, params: { sort: "restock", search: "Gin" }
    assert_select "select[name='sort'] option[value='restock'][selected='selected']"
    assert_select "a[href*='sort=restock']"
  end

  test "filters by a single category" do
    get items_path, params: { category_ids: [ categories(:mixers).id ] }
    assert_response :success
    assert_match "Hendricks Gin", response.body
    assert_match "Simple Syrup", response.body
    assert_no_match(/Buffalo Trace/, response.body)
  end

  test "matching all categories narrows the results" do
    ids = [ categories(:spirits).id, categories(:mixers).id ]

    get items_path, params: { category_ids: ids, category_match: "any" }
    assert_match "Buffalo Trace", response.body
    assert_match "Simple Syrup", response.body

    get items_path, params: { category_ids: ids, category_match: "all" }
    assert_match "Hendricks Gin", response.body
    assert_no_match(/Buffalo Trace/, response.body)
    assert_no_match(/Simple Syrup/, response.body)
  end

  test "combines search with stock status" do
    get items_path, params: { search: "Gin", stock_status: "out_of_stock" }
    assert_match "Hendricks Gin", response.body
    assert_no_match(/Buffalo Trace/, response.body)
  end

  test "category counts reflect the active filter" do
    get items_path, params: { stock_status: "out_of_stock" }
    assert_match "Spirits (1)", response.body
    assert_match "Mixers (1)", response.body
  end

  test "filter state is reflected back into the form" do
    get items_path, params: { search: "Buffalo", item_type: "Alcohol" }
    assert_select "input[name='search'][value='Buffalo']"
    assert_select "select[name='item_type'] option[value='Alcohol'][selected='selected']"
  end

  test "an empty filtered result explains itself" do
    get items_path, params: { search: "nothing matches this" }
    assert_match "No items match your filters", response.body
  end

  test "an empty inventory offers to add the first item" do
    Item.destroy_all
    get items_path
    assert_match "Add your first item", response.body
  end

  test "the out of stock shortcut keeps the other filters" do
    get items_path, params: { search: "Gin", item_type: "Alcohol" }
    assert_select "a[href*='stock_status=out_of_stock']" do |links|
      assert links.any? { |link| link["href"].include?("search=Gin") }
    end
  end
end
