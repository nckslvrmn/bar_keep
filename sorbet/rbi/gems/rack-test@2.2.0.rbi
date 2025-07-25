# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rack-test` gem.
# Please instead update this file by running `bin/tapioca gem rack-test`.


# source://rack-test//lib/rack/test/cookie_jar.rb#6
module Rack; end

# For backwards compatibility with 1.1.0 and below
#
# source://rack-test//lib/rack/test.rb#381
Rack::MockSession = Rack::Test::Session

# source://rack-test//lib/rack/test/cookie_jar.rb#7
module Rack::Test
  class << self
    # Whether the version of rack in use handles encodings.
    #
    # @return [Boolean]
    #
    # source://rack-test//lib/rack/test.rb#375
    def encoding_aware_strings?; end
  end
end

# Represents individual cookies in the cookie jar.  This is considered private
# API and behavior of this class can change at any time.
#
# source://rack-test//lib/rack/test/cookie_jar.rb#10
class Rack::Test::Cookie
  include ::Rack::Utils

  # @return [Cookie] a new instance of Cookie
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#23
  def initialize(raw, uri = T.unsafe(nil), default_host = T.unsafe(nil)); end

  # Order cookies by name, path, and domain.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#106
  def <=>(other); end

  # The explicit or implicit domain for the cookie.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#59
  def domain; end

  # Whether the cookie has a value.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#54
  def empty?; end

  # Whether the cookie is currently expired.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#86
  def expired?; end

  # A Time value for when the cookie expires, if the expires option is set.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#81
  def expires; end

  # Whether the cookie has the httponly flag, indicating it is not available via
  # a javascript API.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#71
  def http_only?; end

  # Cookies that do not match the URI will not be sent in requests to the URI.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#101
  def matches?(uri); end

  # The name of the cookie, will be a string
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#14
  def name; end

  # The explicit or implicit path for the cookie.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#76
  def path; end

  # The raw string for the cookie, without options. Will generally be in
  # name=value format is name and value are provided.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#21
  def raw; end

  # Wether the given cookie can replace the current cookie in the cookie jar.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#49
  def replaces?(other); end

  # Whether the cookie has the secure flag, indicating it can only be sent over
  # an encrypted connection.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#65
  def secure?; end

  # A hash of cookie options, including the cookie value, but excluding the cookie name.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#111
  def to_h; end

  # A hash of cookie options, including the cookie value, but excluding the cookie name.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#120
  def to_hash; end

  # Whether the cookie is valid for the given URI.
  #
  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#91
  def valid?(uri); end

  # The value of the cookie, will be a string or nil if there is no value.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#17
  def value; end

  private

  # The default URI to use for the cookie, including just the host.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#125
  def default_uri; end
end

# Represents all cookies for a session, handling adding and
# removing cookies, and finding which cookies apply to a given
# request.  This is considered private API and behavior of this
# class can change at any time.
#
# source://rack-test//lib/rack/test/cookie_jar.rb#134
class Rack::Test::CookieJar
  # @return [CookieJar] a new instance of CookieJar
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#137
  def initialize(cookies = T.unsafe(nil), default_host = T.unsafe(nil)); end

  # Add a Cookie to the cookie jar.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#197
  def <<(new_cookie); end

  # Return the value for first cookie with the given name, or nil
  # if no such cookie exists.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#150
  def [](name); end

  # Set a cookie with the given name and value in the
  # cookie jar.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#160
  def []=(name, value); end

  # Delete all cookies with the given name from the cookie jar.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#174
  def delete(name); end

  # Return a raw cookie string for the cookie header to
  # use for the given URI.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#208
  def for(uri); end

  # Return the first cookie with the given name, or nil if
  # no such cookie exists.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#166
  def get_cookie(name); end

  # Add a string of raw cookie information to the cookie jar,
  # if the cookie is valid for the given URI.
  # Cookies should be separated with a newline.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#184
  def merge(raw_cookies, uri = T.unsafe(nil)); end

  # Return a hash cookie names and cookie values for cookies in the jar.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#225
  def to_hash; end

  private

  # Yield each cookie that matches for the URI.
  #
  # The cookies are sorted by most specific first. So, we loop through
  # all the cookies in order and add it to a hash by cookie name if
  # the cookie can be sent to the current URI. It's added to the hash
  # so that when we are done, the cookies will be unique by name and
  # we'll have grabbed the most specific to the URI.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#244
  def each_cookie_for(uri); end

  # Ensure the copy uses a distinct cookies array.
  #
  # source://rack-test//lib/rack/test/cookie_jar.rb#143
  def initialize_copy(other); end
end

# source://rack-test//lib/rack/test/cookie_jar.rb#135
Rack::Test::CookieJar::DELIMITER = T.let(T.unsafe(nil), String)

# The default host to use for requests, when a full URI is not
# provided.
#
# source://rack-test//lib/rack/test.rb#33
Rack::Test::DEFAULT_HOST = T.let(T.unsafe(nil), String)

# The ending boundary in multipart requests
#
# source://rack-test//lib/rack/test.rb#42
Rack::Test::END_BOUNDARY = T.let(T.unsafe(nil), String)

# The common base class for exceptions raised by Rack::Test
#
# source://rack-test//lib/rack/test.rb#45
class Rack::Test::Error < ::StandardError; end

# The default multipart boundary to use for multipart request bodies
#
# source://rack-test//lib/rack/test.rb#36
Rack::Test::MULTIPART_BOUNDARY = T.let(T.unsafe(nil), String)

# This module serves as the primary integration point for using Rack::Test
# in a testing environment. It depends on an app method being defined in the
# same context, and provides the Rack::Test API methods (see Rack::Test::Session
# for their documentation). It defines the following methods that are delegated
# to the current session: :request, :get, :post, :put, :patch, :delete, :options,
# :head, :custom_request, :follow_redirect!, :header, :env, :set_cookie,
# :clear_cookies, :authorize, :basic_authorize, :last_response, and :last_request.
#
# Example:
#
#   class HomepageTest < Test::Unit::TestCase
#     include Rack::Test::Methods
#
#     def app
#       MyApp
#     end
#   end
#
# source://rack-test//lib/rack/test/methods.rb#24
module Rack::Test::Methods
  extend ::Forwardable

  # Private accessor to avoid uninitialized instance variable warning in Ruby 2.*
  #
  # source://rack-test//lib/rack/test/methods.rb#90
  def _rack_test_current_session=(_arg0); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def authorize(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def basic_authorize(*args, **_arg1, &block); end

  # Create a new Rack::Test::Session for #app.
  #
  # source://rack-test//lib/rack/test/methods.rb#40
  def build_rack_test_session(_name); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def clear_cookies(*args, **_arg1, &block); end

  # Return the currently actively session.  This is the session to
  # which the delegated methods are sent.
  #
  # source://rack-test//lib/rack/test/methods.rb#55
  def current_session; end

  # source://rack-test//lib/rack/test/methods.rb#68
  def custom_request(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def delete(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def env(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def follow_redirect!(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def get(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def head(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def header(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def last_request(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def last_response(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def options(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def patch(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def post(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def put(*args, **_arg1, &block); end

  # Return the existing session with the given name, or a new
  # rack session.  Always use a new session if name is nil.
  # For backwards compatibility with older rack-test versions.
  #
  # source://rack-test//lib/rack/test/methods.rb#37
  def rack_mock_session(name = T.unsafe(nil)); end

  # Return the existing session with the given name, or a new
  # rack session.  Always use a new session if name is nil.
  #
  # source://rack-test//lib/rack/test/methods.rb#29
  def rack_test_session(name = T.unsafe(nil)); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def request(*args, **_arg1, &block); end

  # source://rack-test//lib/rack/test/methods.rb#68
  def set_cookie(*args, **_arg1, &block); end

  # Create a new session (or reuse an existing session with the given name),
  # and make it the current session for the given block.
  #
  # source://rack-test//lib/rack/test/methods.rb#61
  def with_session(name); end

  private

  # Private accessor to avoid uninitialized instance variable warning in Ruby 2.*
  #
  # source://rack-test//lib/rack/test/methods.rb#90
  def _rack_test_current_session; end
end

# The starting boundary in multipart requests
#
# source://rack-test//lib/rack/test.rb#39
Rack::Test::START_BOUNDARY = T.let(T.unsafe(nil), String)

# Rack::Test::Session handles a series of requests issued to a Rack app.
# It keeps track of the cookies for the session, and allows for setting headers
# and a default rack environment that is used for future requests.
#
# Rack::Test::Session's methods are most often called through Rack::Test::Methods,
# which will automatically build a session when it's first used.
#
# source://rack-test//lib/rack/test.rb#53
class Rack::Test::Session
  include ::Rack::Utils
  include ::Rack::Test::Utils
  extend ::Forwardable

  # Creates a Rack::Test::Session for a given Rack app or Rack::Test::BasicSession.
  #
  # Note: Generally, you won't need to initialize a Rack::Test::Session directly.
  # Instead, you should include Rack::Test::Methods into your testing context.
  # (See README.rdoc for an example)
  #
  # The following methods are defined via metaprogramming: get, post, put, patch,
  # delete, options, and head. Each method submits a request with the given request
  # method, with the given URI and optional parameters and rack environment.
  # Examples:
  #
  #   # URI only:
  #   get("/")                   # GET /
  #   get("/?foo=bar")           # GET /?foo=bar
  #
  #   # URI and parameters
  #   get("/foo", 'bar'=>'baz')  # GET /foo?bar=baz
  #   post("/foo", 'bar'=>'baz') # POST /foo (bar=baz in request body)
  #
  #   # URI, parameters, and rack environment
  #   get("/bar", {}, 'CONTENT_TYPE'=>'foo')
  #   get("/bar", {'foo'=>'baz'}, 'HTTP_ACCEPT'=>'*')
  #
  # The above methods as well as #request and #custom_request store the Rack::Request
  # submitted in #last_request. The methods store a Rack::MockResponse based on the
  # response in #last_response. #last_response is also returned by the methods.
  # If a block is given, #last_response is also yielded to the block.
  #
  # @return [Session] a new instance of Session
  #
  # source://rack-test//lib/rack/test.rb#99
  def initialize(app, default_host = T.unsafe(nil)); end

  # Run a block after the each request completes.
  #
  # source://rack-test//lib/rack/test.rb#118
  def after_request(&block); end

  # Set the username and password for HTTP Basic authorization, to be
  # included in subsequent requests in the HTTP_AUTHORIZATION header.
  #
  # Example:
  #   basic_authorize "bryan", "secret"
  #
  # source://rack-test//lib/rack/test.rb#203
  def authorize(username, password); end

  # Set the username and password for HTTP Basic authorization, to be
  # included in subsequent requests in the HTTP_AUTHORIZATION header.
  #
  # Example:
  #   basic_authorize "bryan", "secret"
  #
  # source://rack-test//lib/rack/test.rb#198
  def basic_authorize(username, password); end

  # Replace the current cookie jar with an empty cookie jar.
  #
  # source://rack-test//lib/rack/test.rb#123
  def clear_cookies; end

  # The Rack::Test::CookieJar for the cookies for the current session.
  #
  # source://rack-test//lib/rack/test.rb#67
  def cookie_jar; end

  # The Rack::Test::CookieJar for the cookies for the current session.
  #
  # source://rack-test//lib/rack/test.rb#67
  def cookie_jar=(_arg0); end

  # Issue a request using the given HTTP verb for the given URI, with optional
  # params and rack environment.  Example:
  #
  #   custom_request "LINK", "/"
  #
  # source://rack-test//lib/rack/test.rb#160
  def custom_request(verb, uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # The default host used for the session for when using paths for URIs.
  #
  # source://rack-test//lib/rack/test.rb#70
  def default_host; end

  # source://rack-test//lib/rack/test.rb#110
  def delete(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # Set an entry in the rack environment to be included on all subsequent
  # requests through the session. Use a value of nil to remove a previously
  # value.  Example:
  #
  #   env "rack.session", {:csrf => 'token'}
  #
  # source://rack-test//lib/rack/test.rb#185
  def env(name, value); end

  # Rack::Test will not follow any redirects automatically. This method
  # will follow the redirect returned (including setting the Referer header
  # on the new request) in the last response. If the last response was not
  # a redirect, an error will be raised.
  #
  # source://rack-test//lib/rack/test.rb#209
  def follow_redirect!; end

  # source://rack-test//lib/rack/test.rb#110
  def get(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # source://rack-test//lib/rack/test.rb#110
  def head(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # Set a header to be included on all subsequent requests through the
  # session. Use a value of nil to remove a previously configured header.
  #
  # In accordance with the Rack spec, headers will be included in the Rack
  # environment hash in HTTP_USER_AGENT form.  Example:
  #
  #   header "user-agent", "Firefox"
  #
  # source://rack-test//lib/rack/test.rb#173
  def header(name, value); end

  # Return the last request issued in the session. Raises an error if no
  # requests have been sent yet.
  #
  # @raise [Error]
  #
  # source://rack-test//lib/rack/test.rb#134
  def last_request; end

  # Return the last response received in the session. Raises an error if
  # no requests have been sent yet.
  #
  # @raise [Error]
  #
  # source://rack-test//lib/rack/test.rb#141
  def last_response; end

  # source://rack-test//lib/rack/test.rb#110
  def options(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # source://rack-test//lib/rack/test.rb#110
  def patch(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # source://rack-test//lib/rack/test.rb#110
  def post(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # source://rack-test//lib/rack/test.rb#110
  def put(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end

  # Issue a request to the Rack app for the given URI and optional Rack
  # environment.  Example:
  #
  #   request "/"
  #
  # source://rack-test//lib/rack/test.rb#150
  def request(uri, env = T.unsafe(nil), &block); end

  # Yield to the block, and restore the last request, last response, and
  # cookie jar to the state they were prior to block execution upon
  # exiting the block.
  #
  # source://rack-test//lib/rack/test.rb#240
  def restore_state; end

  # Set a cookie in the current cookie jar.
  #
  # source://rack-test//lib/rack/test.rb#128
  def set_cookie(cookie, uri = T.unsafe(nil)); end

  private

  # Append a string version of the query params to the array of query params.
  #
  # source://rack-test//lib/rack/test.rb#340
  def append_query_params(query_array, query_params); end

  # close() gets called automatically in newer Rack versions.
  #
  # source://rack-test//lib/rack/test.rb#266
  def close_body(body); end

  # Update environment to use based on given URI.
  #
  # source://rack-test//lib/rack/test.rb#293
  def env_for(uri, env); end

  # Return the multipart content type to use based on the environment.
  #
  # source://rack-test//lib/rack/test.rb#346
  def multipart_content_type(env); end

  # Normalize URI based on given URI/path and environment.
  #
  # source://rack-test//lib/rack/test.rb#271
  def parse_uri(path, env); end

  # Submit the request with the given URI and rack environment to
  # the mock session.  Returns and potentially yields the last response.
  #
  # @yield [@last_response]
  #
  # source://rack-test//lib/rack/test.rb#357
  def process_request(uri, env); end

  class << self
    # source://rack-test//lib/rack/test.rb#57
    def new(app, default_host = T.unsafe(nil)); end
  end
end

# source://rack-test//lib/rack/test.rb#279
Rack::Test::Session::DEFAULT_ENV = T.let(T.unsafe(nil), Hash)

# Wraps a Tempfile with a content type. Including one or more UploadedFile's
# in the params causes Rack::Test to build and issue a multipart request.
#
# Example:
#   post "/photos", "file" => Rack::Test::UploadedFile.new("me.jpg", "image/jpeg")
#
# source://rack-test//lib/rack/test/uploaded_file.rb#14
class Rack::Test::UploadedFile
  # Creates a new UploadedFile instance.
  #
  # Arguments:
  # content :: is a path to a file, or an {IO} or {StringIO} object representing the content.
  # content_type :: MIME type of the file
  # binary :: Whether the file should be set to binmode (content treated as binary).
  # original_filename :: The filename to use for the file. Required if content is StringIO, optional override if not
  #
  # @return [UploadedFile] a new instance of UploadedFile
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#31
  def initialize(content, content_type = T.unsafe(nil), binary = T.unsafe(nil), original_filename: T.unsafe(nil)); end

  # Append to given buffer in 64K chunks to avoid multiple large
  # copies of file data in memory.  Rewind tempfile before and
  # after to make sure all data in tempfile is appended to the
  # buffer.
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#60
  def append_to(buffer); end

  # The content type of the "uploaded" file
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#22
  def content_type; end

  # The content type of the "uploaded" file
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#22
  def content_type=(_arg0); end

  # The path to the tempfile. Will not work if the receiver's content is from a StringIO.
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#49
  def local_path; end

  # Delegate all methods not handled to the tempfile.
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#52
  def method_missing(method_name, *args, &block); end

  # The filename, *not* including the path, of the "uploaded" file
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#16
  def original_filename; end

  # The path to the tempfile. Will not work if the receiver's content is from a StringIO.
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#46
  def path; end

  # The tempfile
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#19
  def tempfile; end

  private

  # Create a tempfile and copy the content from the given path into the tempfile, optionally renaming if
  # original_filename has been set.
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#86
  def initialize_from_file_path(path); end

  # Use the StringIO as the tempfile.
  #
  # @raise [ArgumentError]
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#78
  def initialize_from_stringio(stringio); end

  # @return [Boolean]
  #
  # source://rack-test//lib/rack/test/uploaded_file.rb#71
  def respond_to_missing?(method_name, include_private = T.unsafe(nil)); end
end

# source://rack-test//lib/rack/test/utils.rb#5
module Rack::Test::Utils
  include ::Rack::Utils
  extend ::Rack::Utils
  extend ::Rack::Test::Utils

  # Build a multipart body for the given params.
  #
  # @raise [ArgumentError]
  #
  # source://rack-test//lib/rack/test/utils.rb#34
  def build_multipart(params, _first = T.unsafe(nil), multipart = T.unsafe(nil)); end

  # Build a query string for the given value and prefix. The value
  # can be an array or hash of parameters.
  #
  # source://rack-test//lib/rack/test/utils.rb#11
  def build_nested_query(value, prefix = T.unsafe(nil)); end

  private

  # Append each multipart parameter value to the buffer.
  #
  # source://rack-test//lib/rack/test/utils.rb#100
  def _build_parts(buffer, parameters); end

  # Append the multipart fragment for a parameter that is a file upload to the buffer.
  #
  # source://rack-test//lib/rack/test/utils.rb#133
  def build_file_part(buffer, parameter_name, uploaded_file); end

  # Build the multipart content for uploading.
  #
  # source://rack-test//lib/rack/test/utils.rb#94
  def build_parts(buffer, parameters); end

  # Append the multipart fragment for a parameter that isn't a file upload to the buffer.
  #
  # source://rack-test//lib/rack/test/utils.rb#121
  def build_primitive_part(buffer, parameter_name, value); end

  # Return a flattened hash of parameter values based on the given params.
  #
  # source://rack-test//lib/rack/test/utils.rb#62
  def normalize_multipart_params(params, first = T.unsafe(nil)); end
end

# source://rack-test//lib/rack/test/version.rb#3
Rack::Test::VERSION = T.let(T.unsafe(nil), String)
