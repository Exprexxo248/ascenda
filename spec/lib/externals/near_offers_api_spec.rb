RSpec.describe Externals::NearOffersApi do
  subject { described_class.new }
  let(:location) do
    {
      lat: 10,
      lon: 20,
      rad: 50
    }
  end
  it "success" do
    response = subject.get_offers(location:)
    offer = response.first
    expect(offer).to include("id", "description", "category", "valid_to", "merchants")
  end

  context "failed" do
    it "failed with external api" do
      allow_any_instance_of(HTTParty::Response).to receive(:code).and_return(400)
      expect do
        subject.get_offers(location:)
      end.to raise_error(Errors::NearOffersError)
    end
  end
end
