class PicksController < ApplicationController
  EXCLUDED_CATEGORIES = ["Coffee Shop"]

  def index
    @picks = fetch_picks
  end

  def fetch_picks
    params = {
      "intent" => "checkin",
      "ll" => "37.791442,-122.392723",
      "radius" => 500,
      "categoryId" => "4d4b7105d754a06374d81259",
      "client_id" => ENV['FOURSQUARE_CLIENT_ID'],
      "client_secret" => ENV['FOURSQUARE_CLIENT_SECRET'],
      "v" => Date.today.strftime('%Y%m%d'),
      "limit" => 50
    }

    response = HTTParty.get('https://api.foursquare.com/v2/venues/search', :query => params)
    response = Hashie::Mash.new(response).response.venues
    response.delete_if {|restaurant| EXCLUDED_CATEGORIES.include?(restaurant.categories.first.name)}
    response.sample(6)
  end
end
