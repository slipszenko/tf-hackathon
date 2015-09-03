class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.belongs_to :venue, index: true
      t.belongs_to :category, index: true
    end
  end
end
