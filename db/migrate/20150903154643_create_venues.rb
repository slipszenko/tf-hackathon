class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.decimal :rating
      t.string :address
      t.string :google_url
      t.string :name
      t.string :phone
      t.string :place_id
      t.string :website
      t.string :opening_hours, array: true, default: []
    end
  end
end
