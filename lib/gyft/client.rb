require 'net/https'
require 'digest'
require 'json'

module Gyft
  class Client
    class ServerError < StandardError; end
    class NotFoundError < StandardError; end
    class BadRequestError < StandardError; end
    class UnauthorizedError < StandardError; end
    
    ENDPOINTS = {
      'production' => 'api.gyft.com',
      'sandbox' => 'apitest.gyft.com'
    }

    attr_accessor :api_key, :api_secret, :environment, :http, :reseller

    def initialize(options = {})
      @api_key = options.fetch(:api_key) do
        ENV['GYFT_API_KEY'] || raise(KeyError, "Missing required argument: api_key")
      end

      @api_secret = options.fetch(:api_secret) do
        ENV['GYFT_API_SECRET'] || raise(KeyError, "Missing required argument: api_secret")
      end

      @environment = begin
        environment = options.fetch(:environment) do
          ENV['GYFT_API_ENVIRONMENT'] || 'sandbox'
        end
        unless %w{production sandbox}.include?(environment)
          raise(KeyError, "Invalid argument: environment should be one of 'production' or 'sandbox'")
        end
        environment
      end

      @http = Net::HTTP.new(ENDPOINTS[environment], Net::HTTP.https_default_port)
      http.use_ssl = true
    end

    def cards
      reseller.shop_cards
    end

    def health
      Gyft::Client::Health.new(self)
    end

    def reseller
      @reseller ||= Gyft::Client::Reseller.new(self)
    end

    def partner
      Gyft::Client::Partner.new(self)
    end

    def get(path)
      uri, timestamp = uri_for(path)
      message = Net::HTTP::Get.new(uri.request_uri)
      message['x-sig-timestamp'] = timestamp
      transmit(message)
    end

    def post(path, params = {})
      uri, timestamp = uri_for(path, params)
      message = Net::HTTP::Post.new(uri.request_uri)
      message['x-sig-timestamp'] = timestamp
      transmit(message)
    end

    private

    def uri_for(path, params = {})
      uri = URI("https://#{ENDPOINTS[environment]}/mashery/v1#{path}")
      sig, timestamp = signature
      uri.query = URI.encode_www_form(params.merge({
        api_key: api_key,
        sig: sig
      }))
      [uri, timestamp]
    end

    def signature
      timestamp = Time.now.getutc.to_i.to_s
      plaintext = api_key + api_secret + timestamp
      [Digest::SHA256.new.hexdigest(plaintext), timestamp]
    end

    def transmit(message)
      parse(http.request(message))
    end

    def parse response
      case response
      when Net::HTTPSuccess
        json?(response) ? JSON.parse(response.body) : response.body
      when Net::HTTPNotFound
        raise NotFoundError, "Record not found (404)"
      when Net::HTTPBadRequest
        raise BadRequestError, "Bad request (400)"
      when Net::HTTPUnauthorized
        raise UnauthorizedError, "Access Denied (401)"
      else
        if json?(response)
          raise ServerError, "HTTP #{response.code}: #{JSON.parse(response.body)}"
        else
          raise ServerError, "HTTP #{response.code}: #{response.body}"
        end
      end
    end

    def json?(response)
      content_type = response['Content-Type']
      json_header = content_type && content_type.split(';').first == 'application/json'
      has_body = response.body && response.body.length > 0
      json_header && has_body
    end
  end
end
