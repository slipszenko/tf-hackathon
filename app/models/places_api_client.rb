class PlacesApiClient
  BASE_URL = 'https://maps.googleapis.com/maps/api/place'
  TYPES = %w(food bar cafe restaurant)

  def find_places(coords, radius, types = default_types)
    params = "location=#{coords}&radius=#{radius}&types=#{types || default_types}&key=#{api_key}"
    uri = URI("#{BASE_URL}/nearbysearch/json?#{params}")
    results_for_uri(uri)[:results]
  end

  def place_details(place_id)
    params = "placeid=#{place_id}&key=#{api_key}"
    uri = URI("#{BASE_URL}/details/json?#{params}")
    results_for_uri(uri)[:result]
  end

  private

  def results_for_uri(uri)
    response = Net::HTTP.get(uri)
    JSON.parse(response, symbolize_names: true)
  end

  def default_types
    TYPES.join('|')
  end

  def api_key
    ENV['GOOGLE_PLACES_API_KEY']
  end
end
