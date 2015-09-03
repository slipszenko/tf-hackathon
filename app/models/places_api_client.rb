class PlacesApiClient
  BASE_URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
  TYPES = %w(food bar cafe restaurant)

  def find_places(lat, lon, radius, types)
    url = "#{BASE_URL}location=#{lat},#{lon}&radius=#{radius}&types=#{types || default_types}&key=#{ENV['GOOGLE_PLACES_API_KEY']}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    # JSON.parse(response)
  end

  def default_typess
    TYPES.join('|')
  end

end
