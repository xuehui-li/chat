require 'faraday'

class Link
  alias :read_attribute_for_serialization :send

  attr_reader :url, :title

  def initialize(url)
    @url = url
    set_title
  end

  private

  def set_title
    begin
      body = Faraday.get(url).body
      @title = grab_title_from_body(body) if body
    rescue Faraday::ClientError => fex
      Rails.logger.warn(error_from_exception(fex))
    end
  end

  def grab_title_from_body(body)
    start_idx = body.index('<title>')
    return unless start_idx
    start_idx += '<title>'.size
    end_idx = body.index('</title>')
    return unless end_idx
    body[start_idx..end_idx-1]
  end

  def error_from_exception(ex)
    error = "Running into 'Faraday::ClientError' when calling '#{url}' with message '#{ex.message}'"
    response_body = ex.response[:body] if ex.response
    error += " and response body: #{response_body}" if response_body
    error
  end
end
