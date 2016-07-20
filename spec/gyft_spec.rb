require 'minitest/autorun'
require 'webmock/minitest'
require 'gyft'

describe 'Gyft::Reseller' do

  before do
    @client = Gyft::Client.new(api_key: '123', api_secret: '234')
  end

  describe '.health.check' do
    it 'should return the result' do
      stub_request(:get, /apitest.gyft.com\/mashery/)
        .to_return(status: 200, body: "", headers: {})
      @client.health.check.must_equal(true)
    end
  end
end
