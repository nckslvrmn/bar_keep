require "test_helper"

class PwaTest < ActionDispatch::IntegrationTest
  test "the manifest is served without logging in" do
    get pwa_manifest_path(format: :json)
    assert_response :success
    assert_equal "Bar Keep", response.parsed_body["short_name"]
  end

  test "the service worker precaches digested stylesheets" do
    get pwa_service_worker_path(format: :js)
    assert_response :success
    assert_equal "text/javascript", response.media_type
    assert_match(%r{'/assets/application-\w+\.css'}, response.body)
  end

  test "the layout links the routed manifest and service worker" do
    login_as users(:regular)
    get items_path
    assert_select "link[rel=manifest][href='#{pwa_manifest_path(format: :json)}']"
    assert_match pwa_service_worker_path(format: :js), response.body
  end
end
