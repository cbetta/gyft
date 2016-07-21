require_relative './test_helper'

describe 'Gyft::Transaction' do

  describe '.reload' do
    it "should delegate to the client" do
      @client = Minitest::Mock.new
      @transaction = Gyft::Transaction.new id: 123, client: @client
      @reseller = Minitest::Mock.new
      @transactions = Minitest::Mock.new

      @client.expect :reseller, @reseller
      @reseller.expect :transactions, @transactions
      @transactions.expect :find, {}, [123]

      @transaction.reload

      @client.verify
      @reseller.verify
      @transactions.verify
    end
  end

  describe '.refund' do
    it "should delegate to the client" do
      @client = Minitest::Mock.new
      @transaction = Gyft::Transaction.new id: 123, client: @client
      @reseller = Minitest::Mock.new
      @transactions = Minitest::Mock.new

      @client.expect :reseller, @reseller
      @reseller.expect :transactions, @transactions
      @transactions.expect :refund, {}, [123]

      @transaction.refund

      @client.verify
      @reseller.verify
      @transactions.verify
    end
  end

end
