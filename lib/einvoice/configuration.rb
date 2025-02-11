require "faraday"

module Einvoice
  module Configuration
    VALID_OPTIONS_KEYS = [
      :endpoint_url,
      :client_id,
      :client_secret,
      :format
    ].freeze

    DEFAULT_CLIENT_ID = nil
    DEFAULT_CLIENT_SECRET = nil
    DEFAULT_ENDPOINT_URL = nil
    DEFAULT_FORMAT = ""

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      self.client_id       = DEFAULT_CLIENT_ID
      self.client_secret   = DEFAULT_CLIENT_SECRET
      self.endpoint_url    = DEFAULT_ENDPOINT_URL
      self.format          = DEFAULT_FORMAT
    end
  end
end
