class PlacesApiClient
  BASE_URL = 'https://maps.googleapis.com/maps/api/place'
  TYPES = %w(food bar cafe restaurant)

  def find_places(coords, radius, types = default_types)
    params = "location=#{coords}&radius=#{radius}&types=#{types}&key=#{api_key}"
    url = "#{BASE_URL}/nearbysearch/json?#{params}"
    get_results(url)[:results]
  end

  def place_details(place_id)
    params = "placeid=#{place_id}&key=#{api_key}"
    url = "#{BASE_URL}/details/json?#{params}"
    get_results(url)[:result]
  end

  private

  def get_results(url)
    uri = URI.parse(url)
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
