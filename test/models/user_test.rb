require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "validates username presence" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "validates username uniqueness case-insensitively" do
    User.create!(username: "testuser", password: "password123")
    duplicate = User.new(username: "TestUser", password: "password123")
    assert_not duplicate.valid?
  end

  test "validates password minimum length" do
    user = User.new(username: "newuser", password: "short")
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 6 characters)"
  end

  test "normalizes username to lowercase" do
    user = User.create!(username: "  TestUser  ", password: "password123")
    assert_equal "testuser", user.username
  end

  test "admin? returns true for admin users" do
    assert users(:admin).admin?
    assert_not users(:regular).admin?
  end

  test "guest? returns true for guest users" do
    assert users(:guest).guest?
    assert_not users(:regular).guest?
  end

  test "self.admins returns only admin users" do
    admins = User.admins
    assert admins.all?(&:admin?)
  end

  test "self.regular_users excludes admins and guests" do
    regulars = User.regular_users
    regulars.each do |user|
      assert_not user.admin?
      assert_not user.guest?
    end
  end

  test "destroying user destroys associated sessions and items" do
    user = users(:regular)
    assert_difference "Session.count", -user.sessions.count do
      assert_difference "Item.count", -user.items.count do
        user.destroy
      end
    end
  end
end
