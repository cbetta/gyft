class Gyft::Client::Reseller

  def initialize client
    @client = client
  end

  def shop_cards
    @client.get('/reseller/shop_cards').map do |card|
      card[:client] = @client
      Gyft::Card.new(card)
    end
  end

  def categories
    @client.get('/reseller/categories')['details'].map do |category|
      category[:client] = @client
      Gyft::Category.new(category)
    end
  end

  def merchants
    @client.get('/reseller/merchants')['details'].map do |merchant|
      merchant[:client] = @client
      merchant = Gyft::Merchant.new(merchant)

      if merchant.shop_cards
        merchant.shop_cards = merchant.shop_cards.map do |card|
          card[:client] = @client
          Gyft::Card.new(card)
        end
      end

      if merchant.categories
        merchant.categories = merchant.categories.map do |category|
          category[:client] = @client
          Gyft::Category.new(category)
        end
      end
      
      merchant
    end
  end

  def account
    account = @client.get('/reseller/account')
    account[:client] = @client
    Gyft::Account.new(account)
  end

  def transactions
    Gyft::Client::Transactions.new(@client)
  end

  def transaction
    Gyft::Client::Transactions.new(@client)
  end
end
