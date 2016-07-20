
require 'awesome_print'

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

  def transactions options = {}
    path = transactions_path_for(options)

    @client.get(path).map do |transaction|
      Gyft::Transaction.new(transaction)
    end
  end

  def transaction id
    result = @client.get("/reseller/transaction/#{id}")
    Gyft::Transaction.new(result)
  end

  private

  def transactions_path_for(options)
    last = options[:last]
    first = options[:first]

    path = begin
      if last && last > 0
        "/reseller/transactions/last/#{last}"
      elsif first && first > 0
        "/reseller/transactions/first/#{first}"
      else
        '/reseller/transactions'
      end
    end
  end
end
