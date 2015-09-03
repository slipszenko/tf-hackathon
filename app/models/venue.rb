class Venue
  attr_reader :name, :address, :rating, :place_id, :opening_hours, :google_url
  attr_accessor :category

  def initialize(data)
    @address = data[:formatted_address]
    @name = data[:name]
    @opening_hours = data[:opening_hours]
    @phone = data[:international_phone_number]
    @place_id = data[:place_id]
    @rating = data[:rating]
    @types = data[:types]
    @google_url = data[:url]
    @website = data[:website]
  end

  def open?(datetime)
    if datetime
      open_at?(datetime)
    else
      opening_hours[:open_now]
    end
  end

  private

  def open_at?(datetime)
    opening_times = opening_hours[:periods]
    day = datetime.wday
    time = "#{datetime.hour}#{datetime.min}"

  end
end
