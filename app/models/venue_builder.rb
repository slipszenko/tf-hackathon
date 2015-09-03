class VenueBuilder
  attr_reader :api_client, :place_id

  def initialize(api_client, place_id)
    @api_client = api_client
    @place_id = place_id
  end

  def venue
    details = api_client.place_details(place_id)
    categories = GoogleScraper.new.categories(details[:url])
    venue = Venue.new
    venue.set_attributes(
      details.merge(categories: categories)
    )
    venue
  end
end
