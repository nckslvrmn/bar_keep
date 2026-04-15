require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:admin)
  end

  test "index shows all users" do
    get admin_users_path
    assert_response :success
    assert_match "admin", response.body
    assert_match "regular", response.body
  end

  test "non-admin cannot access admin panel" do
    delete logout_path
    login_as users(:regular)
    get admin_users_path
    assert_redirected_to root_path
  end

  test "guest cannot access admin panel" do
    delete logout_path
    login_as users(:guest)
    get admin_users_path
    assert_redirected_to root_path
  end

  test "create new user" do
    assert_difference "User.count", 1 do
      post admin_users_path, params: {
        user: {
          username: "newuser",
          password: "password123",
          password_confirmation: "password123",
          user_type: "regular"
        }
      }
    end
    assert_redirected_to admin_users_path
  end

  test "cannot delete self" do
    assert_no_difference "User.count" do
      delete admin_user_path(users(:admin))
    end
    assert_match "cannot delete your own", flash[:alert]
  end

  test "cannot remove last admin" do
    patch toggle_admin_admin_user_path(users(:admin))
    assert_match "cannot change your own", flash[:alert]
  end
end
