require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "generates session token on create" do
    session = users(:regular).sessions.create!
    assert_not_nil session.session_token
    assert session.session_token.length > 20
  end

  test "sets expiration on create" do
    session = users(:regular).sessions.create!
    assert_not_nil session.expires_at
    assert session.expires_at > 29.days.from_now
  end

  test "expired? returns true for expired sessions" do
    assert sessions(:expired_session).expired?
    assert_not sessions(:active_session).expired?
  end

  test "extend_expiration! pushes expiration forward" do
    session = sessions(:active_session)
    session.extend_expiration!
    assert session.expires_at > 29.days.from_now
  end

  test "scope active returns only non-expired sessions" do
    active = Session.active
    assert active.all? { |s| s.expires_at > Time.current }
  end

  test "scope expired returns only expired sessions" do
    expired = Session.expired
    assert expired.all? { |s| s.expires_at <= Time.current }
  end

  test "cleanup_expired_sessions runs after create" do
    assert Session.expired.exists?, "precondition: expired session exists"

    assert_difference -> { Session.expired.count }, -1 do
      users(:admin).sessions.create!
    end
  end
end
