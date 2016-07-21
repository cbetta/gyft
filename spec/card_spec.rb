require_relative './test_helper'

describe 'Gyft::Card' do

  describe '.purchase' do
    it "should delegate to the client" do
      @client = Minitest::Mock.new
      @card = Gyft::Card.new id: 123, client: @client
      @partner = Minitest::Mock.new

      @client.expect :partner, @partner
      @partner.expect :purchase, @partner
      @partner.expect :gift_card_direct, {}, [{ shop_card_id: 123, to_email: 'foo@bar.com'}]

      @card.purchase(to_email: 'foo@bar.com')

      @client.verify
      @partner.verify
    end
  end
end
