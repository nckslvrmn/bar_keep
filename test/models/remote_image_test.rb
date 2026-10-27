require "test_helper"

class RemoteImageTest < ActiveSupport::TestCase
  test "refuses loopback addresses" do
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://127.0.0.1/bottle.png") }
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://[::1]/bottle.png") }
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://localhost/bottle.png") }
  end

  test "refuses private and link local addresses" do
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://10.0.0.5/bottle.png") }
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://192.168.1.1/bottle.png") }
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://169.254.169.254/latest/meta-data") }
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("http://[::ffff:127.0.0.1]/bottle.png") }
  end

  test "refuses non http urls" do
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("file:///etc/passwd") }
    assert_raises(RemoteImage::Error) { RemoteImage.fetch("not a url") }
  end

  test "gives up once the deadline has passed" do
    error = assert_raises(RemoteImage::Error) do
      RemoteImage.fetch("https://example.com/bottle.png", deadline: Process.clock_gettime(Process::CLOCK_MONOTONIC) - 1)
    end
    assert_match "timed out", error.message
  end
end
