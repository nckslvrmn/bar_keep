require "net/http"
require "resolv"

class RemoteImage
  MAX_BYTES = 10.megabytes
  MAX_REDIRECTS = 3
  TIMEOUT_SECONDS = 10

  class Error < StandardError; end

  def self.fetch(url, deadline: Process.clock_gettime(Process::CLOCK_MONOTONIC) + TIMEOUT_SECONDS, redirects_left: MAX_REDIRECTS)
    new(url, deadline).fetch(redirects_left)
  end

  def initialize(url, deadline)
    @deadline = deadline
    @uri = URI.parse(url)
    raise Error, "unsupported URL" unless @uri.is_a?(URI::HTTP) && @uri.hostname.present?
  rescue URI::Error => e
    raise Error, e.message
  end

  def fetch(redirects_left)
    response, body = download

    if response.is_a?(Net::HTTPRedirection)
      raise Error, "too many redirects" if redirects_left.zero?
      return self.class.fetch(URI.join(@uri, response["location"]).to_s, deadline: @deadline, redirects_left: redirects_left - 1)
    end

    { io: StringIO.new(body), filename: File.basename(@uri.path).presence || "image", content_type: response.content_type }
  rescue URI::Error, IOError, SystemCallError, SocketError, Timeout::Error, OpenSSL::SSL::SSLError => e
    raise Error, e.message
  end

  private

  # Connecting to the address we vetted stops DNS rebinding between the check and the request.
  def download
    address = public_address
    Net::HTTP.start(@uri.hostname, @uri.port, ipaddr: address, use_ssl: @uri.scheme == "https",
                    open_timeout: remaining_time, read_timeout: remaining_time) do |http|
      http.request(Net::HTTP::Get.new(@uri, "Accept" => "image/*")) do |response|
        return [ response, nil ] if response.is_a?(Net::HTTPRedirection)
        raise Error, "responded with #{response.code}" unless response.is_a?(Net::HTTPSuccess)
        raise Error, "not an image" unless image?(response.content_type)

        return [ response, read_limited(http, response) ]
      end
    end
  end

  def remaining_time
    remaining = @deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
    raise Error, "timed out" unless remaining.positive?

    remaining
  end

  def public_address
    dns = Resolv::DNS.new.tap { |resolver| resolver.timeouts = remaining_time }
    addresses = Resolv.new([ Resolv::Hosts.new, dns ]).getaddresses(@uri.hostname).map { |address| IPAddr.new(address).native }
    raise Error, "could not resolve #{@uri.hostname}" if addresses.empty?
    raise Error, "#{@uri.hostname} is not a public address" unless addresses.all? { |address| public?(address) }

    addresses.first.to_s
  end

  def public?(address)
    !(address.private? || address.loopback? || address.link_local? || address.to_i.zero?)
  end

  def image?(content_type)
    content_type.to_s.start_with?("image/") && content_type != "image/svg+xml"
  end

  def read_limited(http, response)
    body = +""
    response.read_body do |chunk|
      body << chunk
      raise Error, "image is larger than #{MAX_BYTES} bytes" if body.bytesize > MAX_BYTES

      # read_timeout applies per read, so shrink it or a server dripping bytes never hits it.
      http.read_timeout = remaining_time
    end
    body
  end
end
