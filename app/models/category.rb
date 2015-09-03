class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :venues, through: :categorizations

  def with_best_venues
    categories = includes(:venues).order('venues.rating DESC').uniq
    cats_and_venues = {}
    categories.each { |cat| cats_and_venues[cat] = cat.venues.first }
    cats_and_venues
  end
end

