class Gyft::Client::Partner
  def initialize client
    @client = client
  end

  def purchase
    self
  end

  def gift_card_direct params = {}
    params = symbolize(params)
    options = extract(params, :to_email, :shop_card_id)
    options = merge(options, params, :reseller_reference, :notes, :first_name, :last_name, :gender, :birthday)
    result = @client.post("/partner/purchase/gift_card_direct", options)
    Gyft::Transaction.new(result)
  end

  private

  def symbolize params
    params.inject({}){|hash,(k,v)| hash[k.to_sym] = v; hash}
  end

  def extract params, *args
    options = {}
    args.each do |arg|
      options[arg] = params.fetch(arg)
    end
    options
  end

  def merge options, params, *args
    args.each do |arg|
      options[arg] = params[arg] if params[arg]
    end
    options
  end
end
