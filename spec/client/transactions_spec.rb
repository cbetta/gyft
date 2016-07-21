require_relative '../test_helper'

describe 'Gyft::Client::Transactions' do
  before do
    @client = Minitest::Mock.new
    @transaction = { id: '123' }
    @transactions = Gyft::Client::Transactions.new @client
  end

  describe '.find' do
    it "should return if succesful" do
      @client.expect :get, @transaction, ["/reseller/transaction/123"]
      result = @transactions.find(123)
      result.id.must_equal '123'
      @client.verify
    end
  end

  describe '.all' do
    it "should return if succesful" do
      @client.expect :get, [@transaction], ["/reseller/transactions"]
      result = @transactions.all
      result.first.id.must_equal '123'
      @client.verify
    end
  end

  describe '.first' do
    it "should return if succesful" do
      @client.expect :get, [@transaction], ["/reseller/transactions/first/10"]
      result = @transactions.first(10)
      result.first.id.must_equal '123'
      @client.verify
    end
  end

  describe '.last' do
    it "should return if succesful" do
      @client.expect :get, [@transaction], ["/reseller/transactions/last/10"]
      result = @transactions.last(10)
      result.first.id.must_equal '123'
      @client.verify
    end
  end

  describe '.refund' do
    it "should return if succesful" do
      @client.expect :post, @transaction, ["/reseller/transaction/refund", {id: 123}]
      result = @transactions.refund(123)
      result.id.must_equal '123'
      @client.verify
    end
  end
end
