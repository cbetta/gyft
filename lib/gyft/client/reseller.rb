class Gyft::Client::Reseller

  def initialize client
    @client = client
  end

  def shop_cards
    @client.get('/reseller/shop_cards').map do |card|
      Gyft::Card.new(card)
    end
  end

  def categories
    @client.get('/reseller/categories')['details'].map do |category|
      Gyft::Category.new(category)
    end
  end

  def merchants
    @client.get('/reseller/merchants')['details'].map do |merchant|
      merchant = Gyft::Merchant.new(merchant)
      merchant.shop_cards = merchant.shop_cards.map do |card|
        Gyft::Card.new(card)
      end
      merchant.categories = merchant.categories.map do |category|
        Gyft::Category.new(category)
      end
      merchant
    end
  end

  def account
    result = @client.get('/reseller/account')
    Gyft::Account.new(result)
  end

  def transactions
    Gyft::Client::Transactions.new(@client)
  end

  def transaction
    Gyft::Client::Transactions.new(@client)
  end
end
