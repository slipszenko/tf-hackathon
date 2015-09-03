class Venue < ActiveRecord::Base
  has_many :types
  has_many :categories

  before_create :create_categories, :create_types, :set_attributes

  def initialize(data)
    @data = data
  end

  def open?(datetime)
    day = datetime.wday
    time = "#{datetime.hour}#{datetime.min}"
  end

  private

  attr_reader :data, :opening_hours

  def create_categories
    data[:categories].each { |c_name| categories.new(name: c_name) }
  end

  def create_types
    data[:types].each { |t_name| types.new(name: t_name) }
  end

  def set_attributes
    address = data[:formatted_address]
    name = data[:name]
    opening_hours = opening_hours[:periods]
    phone = data[:international_phone_number]
    place_id = data[:place_id]
    rating = data[:rating]
    types = data[:types]
    google_url = data[:url]
    website = data[:website]
  end
end
