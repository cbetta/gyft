require_relative '../test_helper'

describe 'Gyft::Client::Reseller' do
  before do
    @client = Minitest::Mock.new
    @reseller = Gyft::Client::Reseller.new @client
  end

  describe '.shop_cards' do
    it "should return if succesful" do
      @cards = [{ id: '123' }]
      @client.expect :get, @cards, ["/reseller/shop_cards"]
      result = @reseller.shop_cards
      result.first.id.must_equal '123'
      @client.verify
    end
  end

  describe '.categories' do
    it "should return if succesful" do
      @categories = { 'details' => [{ id: '123' }] }
      @client.expect :get, @categories, ["/reseller/categories"]
      result = @reseller.categories
      result.first.id.must_equal '123'
      @client.verify
    end
  end

  describe '.merchants' do
    it "should return if succesful" do
      @merchants = { 'details' => [{ id: '123' }] }
      @client.expect :get, @merchants, ["/reseller/merchants"]
      result = @reseller.merchants
      result.first.id.must_equal '123'
      @client.verify
    end
  end

  describe '.account' do
    it "should return if succesful" do
      @account = { id: '123' }
      @client.expect :get, @account, ["/reseller/account"]
      result = @reseller.account
      result.id.must_equal @account[:id]
      @client.verify
    end
  end

  describe '.transaction' do
    it "should return a Gyft::Client::Transactions object" do
      @reseller.transaction.must_be_instance_of Gyft::Client::Transactions
    end
  end

  describe '.transactions' do
    it "should return a Gyft::Client::Transactions object" do
      @reseller.transactions.must_be_instance_of Gyft::Client::Transactions
    end
  end
end
