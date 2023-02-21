class NearOffersRequest
  include ActiveModel::Model

  attr_accessor :lat, :lon, :checkin_date, :rad

  validates :checkin_date, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :rad, presence: true, numericality: { greater_than: 0, less_than: 1000 }
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lon, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validate :date_validation

  private

  def date_valid?
    (Date.today - 10.years..(Date.today + 10.years)).cover?(checkin_date)
  end

  def date_validation
    errors.add(:checkin_date, "is out of range") unless date_valid?
  end
end

class NearOffersController < ApplicationController
  before_action :validate_get_params, only: [:get]

  def get
    req = params[:req]
    location = { lat: req.lat, lon: req.lon, rad: req.rad }
    checkin_date = req.checkin_date
    offers = NearbyOffers.new.call(location:, checkin_date:)
    render json: OfferSerializer.new(offers).serializable_hash.to_json
  end

  private

  def validate_get_params
    %w[lat lon rad checkin_date].each { |key| params.require(key) }
    %w[lat lon rad].each { |key| params[key] = params[key].to_f }
    params[:checkin_date] = Date.parse(params[:checkin_date])
    params[:req] = NearOffersRequest.new(params.permit(:lat, :lon, :rad, :checkin_date))
    params[:req].validate!
  rescue ActiveModel::ValidationError => e
    raise Errors::BadRequest.new(message: e.message)
  end
end
