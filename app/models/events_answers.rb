class EventsAnswers < ActiveRecord::Base

  def set_attributes(data)
    self.form_id = data[:form_id]
    self.answer = data[:answer]
  end
end