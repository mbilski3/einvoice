require "faraday_middleware"
require "faraday/response/decode_tradevan"

module Einvoice
  module Connection
    private

    def connection(options = {})
      connection_options = {
        headers: { "Accept" => "application/#{format}; charset=utf-8" },
        url: endpoint_url
      }.merge(options)

      ::Faraday::Connection.new(connection_options) do |connection|
        connection.request :url_encoded

        connection.adapter Faraday.default_adapter
      end
    end
  end
end
