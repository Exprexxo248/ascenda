# frozen_string_literal: true

require "rails_helper"

RSpec.describe NearOffersController do
  context "invalid params", type: :controller do
    it "failed when lat is out of [-90, 90]" do
      get :get , params: { lat: 91, lon: 180, rad: -20, checkin_date: "2019-12-25" }
      expect(response.status).to eq(400)
    end
    it "failed when date is not in format " do
      get :get , params: { lat: 91, lon: 180, rad: -20, checkin_date: "20109-12-25" }
      expect(response.status).to eq(400)
    end
  end

  context "is success" do
  end
end
