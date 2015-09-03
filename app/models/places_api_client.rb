class PlacesApiClient
  BASE_URL = 'https://maps.googleapis.com/maps/api/place'
  TYPES = "food|bar|cafe|restaurant"

  attr_reader :next_page_token

  def find_places(coords, radius)
    params = "location=#{coords}&radius=#{radius}&types=#{TYPES}"
    nearby_search(params)
  end

  def find_more_places
    return unless token
    params = "next_page_token=#{token}"
    nearby_search(params)
  end

  def place_details(place_id)
    params = "placeid=#{place_id}&key=#{api_key}"
    url = "#{BASE_URL}/details/json?#{params}"
    get_and_parse_response(url)[:result]
  end

  private

  def nearby_search(params)
    url = "#{BASE_URL}/nearbysearch/json?#{params}&key=#{api_key}"
    response = get_and_parse_response(url)
    @token = response[:next_page_token]
    response[:results]
  end

  def get_and_parse_response(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response, symbolize_names: true)
  end

  def api_key
    ENV['GOOGLE_PLACES_API_KEY']
  end
end
