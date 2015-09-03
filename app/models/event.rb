class Event < ActiveRecord::Base
  has_many :events_answers

  def set_attributes(data)
    self.form_id = data[:form_id]
    self.n_subscribers = data[:n_subscribers]
    self.subscriber_phones = data[:subscriber_phones]
    self.options = data[:options]
  end
end