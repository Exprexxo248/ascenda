class NearOffersRequest
  include ActiveModel::Model
  attr_accessor :lat, :lon, :checkin_date, :rad

  validates :checkin_date, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :rad, numericality: { greater_than: 0, less_than: 1000 }
  validates :lat, numericality: { greater_than_or_equal_t0: -90, less_than_or_equal_to: 90 }
  validates :lon, numericality: { greater_than_or_equal_t0: -180, less_than_or_equal_to: 180 }
end

class NearOffersController < ApplicationController
  before_action :validate_params, only: [:get]

  def get
    request = NearOffersRequest.new(params.permit(:lat, :lon, :rad, :checkin_date))
    raise Errors::BadRequest.new(message: "Params Errors") unless request.valid?

    location = { lat: params[:lat], lon: params[:lon], rad: params[:rad] }
    checkin_date = params[:checkin_date]
    offers = NearbyOffers.new.call(location:, checkin_date:)
    render json: OfferSerializer.new(offers).serializable_hash.to_json
  end

  private

  def validate_params
    %w[lat lon rad].each do |key|
      params.require(key)
      params[key] = params[key].to_f
    end
    Date.parse(params[:checkin_date])
  end
end
