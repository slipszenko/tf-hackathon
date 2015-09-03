class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :venues, through: :categorizations

  def self.with_best_venues
    categories = includes(:venues).order('venues.rating DESC').uniq
    cats_and_venues = {}
    categories.each { |cat| cats_and_venues[cat.name] = cat.venues.first.place_id }
    cats_and_venues
  end
end

