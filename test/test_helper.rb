ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  private

  def login_as(user, password: "password123")
    post login_path, params: { username: user.username, password: password }
  end

  def with_brave_api_key(key = "test-key")
    original = ENV["BRAVE_SEARCH_API_KEY"]
    ENV["BRAVE_SEARCH_API_KEY"] = key
    yield
  ensure
    ENV["BRAVE_SEARCH_API_KEY"] = original
  end

  def stub_class_method(klass, name, implementation)
    original = klass.method(name)
    klass.define_singleton_method(name) { |*args, **kwargs| implementation.call(*args, **kwargs) }
    yield
  ensure
    klass.define_singleton_method(name, original)
  end
end
