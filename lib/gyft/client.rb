require 'net/https'
require 'json'

module Gyft
  class Client
    ENDPOINTS = {
      production: 'https://api.gyft.com/mashery/v1',
      sandbox: 'https://apitest.gyft.com/mashery/v1'
    }

    attr_accessor :api_key, :api_secret, :environment

    def initialize options
      self.api_key = options[:api_key] ||
        ArgumentError.new("Missing required argument: api_key")
      self.api_secret = options[:api_secret] ||
        ArgumentError.new("Missing required argument: api_secret")
      self.environment = begin
        environment = options[:environment] || :sandbox
        unless [:environment, :sandbox].include?(environment)
          raise ArgumentError.new("Invalid argument: environment should be either :production or :sandbox")
        end
        environment
      end
    end

    def health
      Gyft::Health.new(self)
    end

    def get path
      uri = uri_for(path)
      message = Net::HTTP::Get.new(uri.request_uri)
      parse(request(uri, message))
    end

    private

    def uri_for path
      uri = URI("#{ENDPOINTS[environment]}#{path}")
      uri.query = URI.encode_www_form({
        api_key: api_key,
        sig: signature
      })
      uri
    end

    def signature
      timestamp = Time.now.getutc.to_i.to_s
      plaintext = api_key + api_secret + timestamp
      Digest::SHA256.new.hexdigest(plaintext)
    end

    def request(uri, message)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.request(message)
    end

    def parse response
      case response
      when Net::HTTPSuccess
        if response.body && response.body.length > 0
        else
          return true
        end
      end
    end
  end
end
