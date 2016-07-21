class Gyft::Client::Transactions

  def initialize client
    @client = client
  end

  def find id
    transaction = @client.get("/reseller/transaction/#{id}")
    transaction[:client] = @client
    Gyft::Transaction.new(transaction)
  end

  def all
    @client.get('/reseller/transactions').map do |transaction|
      transaction[:client] = @client
      Gyft::Transaction.new(transaction)
    end
  end

  def first number_of_records
    @client.get("/reseller/transactions/first/#{number_of_records}").map do |transaction|
      transaction[:client] = @client
      Gyft::Transaction.new(transaction)
    end
  end

  def last number_of_records
    @client.get("/reseller/transactions/last/#{number_of_records}").map do |transaction|
      transaction[:client] = @client
      Gyft::Transaction.new(transaction)
    end
  end

  def refund id
    transaction = @client.post("/reseller/transaction/refund", id: id)
    transaction[:client] = @client
    Gyft::Refund.new(transaction)
  end
end
