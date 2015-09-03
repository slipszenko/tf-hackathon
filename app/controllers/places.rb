get '/places' do
  api_client = PlacesApiClient.new
  results = api_client.find_places(
    '41.387063,2.170655',
    1000
  )
  venues = results.map do |result|
    place_id = result[:place_id]
    details = api_client.place_details(place_id)
    venue = Venue.new(details)
    # venue.category = GoogleScraper.new.category(venue.google_url)
    # venue
  end
  binding.pry
  venues.to_s
end
