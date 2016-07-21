require_relative './test_helper'

describe 'Gyft::Client' do
  before do
    @client = Gyft::Client.new(api_key: '123', api_secret: '234')
  end

  describe '.initialize' do
    it "should return successful with the right params" do
      client = Gyft::Client.new(api_key: '123', api_secret: '234')
      client.must_be_instance_of Gyft::Client
      client.api_key.must_equal '123'
      client.api_secret.must_equal '234'
      client.environment.must_equal 'sandbox'
    end

    it "should be able to accept another environment" do
      client = Gyft::Client.new(api_key: '123', api_secret: '234', environment: 'production')
      client.environment.must_equal 'production'
    end

    it "should return successful with the ENV variables set" do
      ENV['GYFT_API_KEY'] = '123'
      ENV['GYFT_API_SECRET'] = '234'
      ENV['GYFT_API_ENVIRONMENT'] = 'production'

      client = Gyft::Client.new
      client.must_be_instance_of Gyft::Client
      client.api_key.must_equal '123'
      client.api_secret.must_equal '234'
      client.environment.must_equal 'production'

      ENV.delete('GYFT_API_KEY')
      ENV.delete('GYFT_API_SECRET')
      ENV.delete('GYFT_API_ENVIRONMENT')
    end

    it "should raise without the right params" do
      assert_raises KeyError do
        Gyft::Client.new
      end
    end
  end

  describe '.cards' do
    it "should delegate to Gyft::Reseller" do
      @reseller = Minitest::Mock.new
      @client.reseller = @reseller
      @reseller.expect :shop_cards, nil
      @client.cards
      @reseller.verify
    end
  end

  describe '.health' do
    it "should return a Gyft::Client::Health object" do
      @client.health.must_be_instance_of Gyft::Client::Health
    end
  end

  describe '.reseller' do
    it "should return a Gyft::Client::Reseller object" do
      @client.reseller.must_be_instance_of Gyft::Client::Reseller
    end
  end

  describe '.partner' do
    it "should return a Gyft::Client::Partner object" do
      @client.partner.must_be_instance_of Gyft::Client::Partner
    end
  end

  describe '.get' do
    it "should return the json on success" do
      stub_request(:get, /apitest.gyft.com\/mashery\/v1\/reseller\/categories/).
        to_return(:status => 200, :body => '{"status":0,"details":[{"id":4,"name":"Babies & Children"}]}', :headers => { 'Content-Type' =>  'application/json'})

      result = @client.get('/reseller/categories')
      result['details'].first['id'].must_equal 4
    end

    it "should raise on 404" do
      stub_request(:get, /apitest.gyft.com\/mashery\/v1\/reseller\/categories/).
        to_return(:status => 404)

      assert_raises Gyft::Client::NotFoundError do
        @client.get('/reseller/categories')
      end
    end
  end

  describe '.post' do
    it "should return the json on success" do
      body = '{"id":"1234","status":0,"gf_reseller_id":"asdasd","gf_reseller_transaction_id":123,"email":"foo@bar.com","gf_order_id":123,"gf_order_detail_id":123,"gf_gyfted_card_id":123,"invalidated":false}'
      stub_request(:post, /apitest.gyft.com\/mashery\/v1\/reseller\/transactions\/refund/).
        to_return(:status => 200, :body => body, :headers => { 'Content-Type' =>  'application/json'})

      result = @client.post('/reseller/transactions/refund', id: '123')
      result['id'].must_equal '1234'
    end

    it "should handle a bad request" do
      stub_request(:post, /apitest.gyft.com\/mashery\/v1\/reseller\/transactions\/refund/).
        to_return(:status => 400)

        assert_raises Gyft::Client::BadRequestError do
          @client.post('/reseller/transactions/refund', id: '123')
        end
    end
  end

end
