# frozen_string_literal: true

# This Services used to access to the Near By Offers API
class NearbyOffers
  CATEGORY_MAPPING = {
    Restaurant: 1,
    Retail: 2,
    Hotel: 3,
    Activity: 4
  }.freeze

  ALLOWED_CATEGORY = [CATEGORY_MAPPING[:Restaurant],
                      CATEGORY_MAPPING[:Retail],
                      CATEGORY_MAPPING[:Activity]].freeze

  NUM_OF_RESULTS = 2

  def call(location:, checkin_date:)
    offers = parse_result(Externals::NearOffersApi.new.get_offers(location:))

    offers = offers.select do |offer|
      ALLOWED_CATEGORY.include?(offer.category) && # Only select category in SELECTED_CATEGORY
        (offer.valid_to >= checkin_date + 5.days) # valid till checkin_date + 5
    end

    return [] if offers == []

    offers_by_categories = offers.sort_by { |offer| offer.closest_merchant.distance }.group_by(&:category)

    if offers_by_categories.size == 1
      offers_by_categories.values.first[0..NUM_OF_RESULTS]
    else
      [offers_by_categories.values.first[0], offers_by_categories.values.second[0]]
    end
  end

  private

  def parse_result(offers)
    offers.map do |offer|
      Offer.new(offer)
    end
  end
end
