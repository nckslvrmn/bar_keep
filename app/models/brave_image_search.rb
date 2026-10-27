require "net/http"

class BraveImageSearch
  ENDPOINT = URI("https://api.search.brave.com/res/v1/images/search")
  RESULT_COUNT = 24
  # Brave has no background filter, so bias the query toward product shots.
  BACKGROUND_HINT = "white background"
  CACHE_TTL = 1.day

  class Error < StandardError; end

  def self.api_key
    ENV["BRAVE_SEARCH_API_KEY"].presence
  end

  def self.enabled?
    api_key.present?
  end

  def self.search(query)
    Rails.cache.fetch([ "brave_image_search", query.squish.downcase ], expires_in: CACHE_TTL) { fetch_results(query) }
  end

  def self.fetch_results(query)
    uri = ENDPOINT.dup
    uri.query = URI.encode_www_form(q: "#{query} #{BACKGROUND_HINT}", count: RESULT_COUNT, safesearch: "strict")
    request = Net::HTTP::Get.new(uri, "Accept" => "application/json", "X-Subscription-Token" => api_key)

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 10) do |http|
      http.request(request)
    end
    raise Error, "Brave responded with #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body).fetch("results", []).filter_map { |result| parse_result(result) }
  rescue IOError, SystemCallError, SocketError, Timeout::Error, OpenSSL::SSL::SSLError, JSON::ParserError => e
    raise Error, e.message
  end

  def self.parse_result(result)
    thumbnail_url = result.dig("thumbnail", "src")
    image_url = result.dig("properties", "url")
    return if thumbnail_url.blank? || image_url.blank?

    { title: result["title"].to_s, thumbnail_url: thumbnail_url, image_url: image_url }
  end
  private_class_method :fetch_results, :parse_result
end
