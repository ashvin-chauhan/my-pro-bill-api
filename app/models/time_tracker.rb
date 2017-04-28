class TimeTracker < ApplicationRecord
  acts_as_paranoid

  # Callback
  after_save_commit :update_total_time

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

  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end

  private

  def update_total_time
    
  end
end
