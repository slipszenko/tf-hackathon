get '/places' do
  api_client = PlacesApiClient.new
  results = api_client.find_places(
    '41.387063,2.170655',
    1000
  )

  venues = results.map do |result|
    place_id = result[:place_id]
    Venue.find_by(place_id: place_id) || VenueBuilder.new(api_client, place_id).venue
  end

  venues.to_s
end
