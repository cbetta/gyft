class Gyft::Transaction < OpenStruct
  def reload
    client.reseller.transactions.find(id)
  end

  def refund
    client.reseller.transactions.refund(id)
  end
end
