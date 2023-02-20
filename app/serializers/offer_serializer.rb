class OfferSerializer < BaseSerializer
  attributes :title, :category, :valid_to

  attribute :merchants do |obj|
    [obj.closest_merchant]
  end
end

# class MerchantSerializer < ActiveModel::Serializer
#   attributes :id, :name, :distance
# end
