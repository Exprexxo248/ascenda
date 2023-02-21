class Offer
  include ActiveModel::Validations
  attr_reader :id, :title, :category, :merchants, :valid_to

  def initialize(offer)
    @id = offer["id"]
    @title = offer["title"]
    @category = offer["category"]
    @merchants = offer["merchants"].map! { |merchant| Merchant.new(merchant) }
    @valid_to = Date.parse(offer["valid_to"])
  end

  def closest_merchant
    @closest_merchant ||= @merchants.min_by(&:distance)
  end
end
