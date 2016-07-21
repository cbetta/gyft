require_relative '../test_helper'

describe 'Gyft::Client::Health' do

  describe '.check' do
    it "should return if succesful" do
      @client = Minitest::Mock.new
      @health = Gyft::Client::Health.new @client

      @client.expect :get, nil, ["/health/check"]
      @health.check.must_equal true
      @client.verify
    end

    it "should catch a SocketError" do
      @client = Gyft::Client.new(api_key: "123", api_secret: "234")
      @health = Gyft::Client::Health.new @client

      @client.stub :get, ->(path){ raise SocketError.new } do
        @health.check.must_equal false
      end
    end
  end
end
