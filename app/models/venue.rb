class Venue < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations

  before_create :initialize_categories

  def set_attributes(data)
    initialize_categories(data[:categories])
    self.address = data[:formatted_address]
    self.name = data[:name]
    self.opening_hours = data[:opening_hours][:periods]
    self.phone = data[:international_phone_number]
    self.place_id = data[:place_id]
    self.rating = data[:rating]
    self.google_url = data[:url]
    self.website = data[:website]
  end

  def open?(datetime)
    day = datetime.wday
    time = "#{datetime.hour}#{datetime.min}"
  end

  private

  def initialize_categories(category_names)
    category_names.each { |c_name| categories.new(name: c_name) }
  end
end
