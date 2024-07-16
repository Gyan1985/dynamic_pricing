require 'net/http'
require 'json'

class CompetitorPriceService
  API_URL = "#{ENV['SINATRA_API']}?api_key=#{ENV['API_KEY']}"

  def fetch_prices
    uri = URI(API_URL)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
