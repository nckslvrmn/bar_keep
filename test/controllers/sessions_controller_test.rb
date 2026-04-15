require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "get login page" do
    get login_path
    assert_response :success
  end

  test "redirects to root if already logged in" do
    login_as users(:regular)
    get login_path
    assert_redirected_to root_path
  end

  test "login with valid credentials" do
    post login_path, params: { username: "regular", password: "password123" }
    assert_redirected_to root_path
    follow_redirect!
    assert_match "Welcome back", flash[:notice]
  end

  test "login with invalid credentials" do
    post login_path, params: { username: "regular", password: "wrong" }
    assert_response :unprocessable_entity
    assert_match "Invalid", flash[:alert]
  end

  test "login is case-insensitive" do
    post login_path, params: { username: "REGULAR", password: "password123" }
    assert_redirected_to root_path
  end

  test "logout destroys session" do
    login_as users(:regular)
    delete logout_path
    assert_redirected_to login_path

    get items_path
    assert_redirected_to login_path
  end
end
