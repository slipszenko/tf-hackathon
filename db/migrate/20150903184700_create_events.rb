class CreateEvents < ActiveRecord::Migration
    def change
        create_table :events do |t|
            t.string :form_id
            t.integer :n_subscribers
            t.string :subscriber_phones
            t.string :options
        end

        create_table :events_answers do |t|
            t.string :form_id
            t.string :answer
        end
    end
end