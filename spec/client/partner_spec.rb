require_relative '../test_helper'

describe 'Gyft::Client::Partner' do

  describe '.purchase.gift_card_direct' do
    before do
      @client = Minitest::Mock.new
      @transaction = { id: '123' }
      @partner = Gyft::Client::Partner.new @client
      @params = { to_email: 'foo@bar.com', shop_card_id: '234' }
    end

    it "should return if succesful" do
      @client.expect :post, @transaction, ["/partner/purchase/gift_card_direct", @params]
      result = @partner.purchase.gift_card_direct(@params)
      result.id.must_equal '123'
      @client.verify
    end

    it "should error if params are missing" do
      @params.delete(:to_email)
      assert_raises KeyError do
        @partner.purchase.gift_card_direct(@params)
      end
    end

    it "should ignore invalid params" do
      @new_params = @params.dup
      @new_params[:foo] = 'bar'

      @client.expect :post, @transaction, ["/partner/purchase/gift_card_direct", @params]
      @partner.purchase.gift_card_direct(@new_params)
      @client.verify
    end

    it "should symbolize keys" do
      @new_params = { 'to_email' => 'foo@bar.com', 'shop_card_id' => '234' }

      @client.expect :post, @transaction, ["/partner/purchase/gift_card_direct", @params]
      @partner.purchase.gift_card_direct(@new_params)
      @client.verify
    end
  end
end
