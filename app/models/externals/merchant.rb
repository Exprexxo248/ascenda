class Merchant
  include ActiveModel::Validations
  attr_accessor :id, :name, :distance

  def initialize(merchant)
    @id = merchant["id"]
    @name = merchant["name"]
    @distance = merchant["distance"]
  end
end
