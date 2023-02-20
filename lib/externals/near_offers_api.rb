# This app will handle intergration from external ApplicationJob
# I will not handle bussiness in this class
#
require_relative "../../config/environment"
module Externals
  class NearOffersApi
    include HTTParty
    base_uri "61c3deadf1af4a0017d990e7.mockapi.io"

    DEFAULT_RAD = 10

    def get_offers(location:)
      rad = location[:rad] || DEFAULT_RAD
      data = { query: { lat: location[:lat], lon: location[:lon], rad: } }
      request(:get, "/offers/near_by", data:)
    end

    private

    def request(method, url, data = nil)
      res = if method == :get
              self.class.get url, query: data
            else
              self.class.send :method, url, query: data
            end
      case res.code
      when 200
        JSON.parse(res.body)["offers"]
      when 429
        sleep 1
        request(method:, url:, data:)
      else
        raise Errors::NearOffersError.new(message: "Failed (#{res.code}) to request #{method} #{url}")
      end
    end
  end
end
