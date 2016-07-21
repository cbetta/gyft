class Gyft::Client::Transactions

  def initialize client
    @client = client
  end

  def find id
    result = @client.get("/reseller/transaction/#{id}")
    Gyft::Transaction.new(result)
  end

  def all
    @client.get('/reseller/transactions').map do |transaction|
      Gyft::Transaction.new(transaction)
    end
  end

  def first number_of_records
    @client.get("/reseller/transactions/first/#{number_of_records}").map do |transaction|
      Gyft::Transaction.new(transaction)
    end
  end

  def last number_of_records
    @client.get("/reseller/transactions/last/#{number_of_records}").map do |transaction|
      Gyft::Transaction.new(transaction)
    end
  end

  def refund id
    result = @client.post("/reseller/transaction/refund", id: id)
    Gyft::Refund.new(result)
  end
end
