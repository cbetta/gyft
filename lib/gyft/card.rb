class Gyft::Card < OpenStruct
  def purchase params = {}
    params[:shop_card_id] = id
    client.partner.purchase.gift_card_direct(params)
  end
end
