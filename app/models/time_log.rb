class TimeLog < ApplicationRecord
  acts_as_paranoid

  # Assoviations
  belongs_to :time_tracker

  # Getter methods
  def checkin
    self[:checkin].try(:strftime, "%l:%M %p")
  end

  def checkout
    self[:checkout].try(:strftime, "%l:%M %p")
  end

  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
