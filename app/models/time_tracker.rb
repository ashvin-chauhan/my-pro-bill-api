class TimeTracker < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :worker, class_name: "User"
  belongs_to :client, class_name: "User"
  has_many   :time_logs, dependent: :destroy
  accepts_nested_attributes_for :time_logs, allow_destroy: true

  enum current_status: { checkin: 0, checkout: 1 }

  # Getter methods
  def date
    self[:date].to_s
  end
end
