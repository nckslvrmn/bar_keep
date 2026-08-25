require "test_helper"

class ContentSecurityPolicyTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:regular)
  end

  test "every inline script carries a nonce" do
    get items_path
    assert_response :success

    inline_scripts = response.body.scan(%r{<script\b([^>]*)>(.*?)</script>}m)
      .reject { |attributes, body| attributes.include?("src=") || body.strip.empty? }

    assert inline_scripts.any?, "expected the layout to render inline scripts"

    inline_scripts.each do |attributes, _body|
      assert_match(/nonce="/, attributes, "inline script rendered without a nonce: #{attributes}")
    end
  end

  test "nothing is loaded from an external host" do
    get items_path
    assert_response :success
    assert_no_match(%r{(?:src|href)="https?://}, response.body)
  end

  test "bootstrap is served from this app" do
    get items_path
    assert_match(/href="\/assets\/bootstrap\.min-\w+\.css"/, response.body)
    assert_match(/src="\/assets\/bootstrap\.bundle\.min-\w+\.js"/, response.body)
  end

  test "the policy does not allow unsafe inline scripts" do
    get items_path
    assert_no_match(/script-src[^;]*'unsafe-inline'/, response.headers["Content-Security-Policy"].to_s)
  end

  test "nonces differ between requests" do
    get items_path
    first = response.headers["Content-Security-Policy"][/'nonce-([^']+)'/, 1]

    get items_path
    second = response.headers["Content-Security-Policy"][/'nonce-([^']+)'/, 1]

    assert first.present?
    assert_not_equal first, second
  end
end
