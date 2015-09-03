class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :venue

  validates :category_id, uniqueness: { scope: :venue_id }
end
