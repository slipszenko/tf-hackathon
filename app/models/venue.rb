class Venue < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations

  def set_attributes(data)

    initialize_categories(data[:categories])
    update(
      address: data[:formatted_address],
      name: data[:name],
      # opening_hours: data[:opening_hours][:periods],
      phone: data[:international_phone_number],
      place_id: data[:place_id],
      rating: data[:rating],
      google_url: data[:url],
      website: data[:website]
    )
  end

  # def open?(datetime)
  #   day = datetime.wday
  #   time = "#{datetime.hour}#{datetime.min}"
  # end

  private

  def initialize_categories(category_names)
    category_names.each { |c_name| categories.new(name: c_name) }
  end
end
