class TimeTracker < ApplicationRecord
  include Filterable
  acts_as_paranoid

  # Callback
  after_save :update_total_time

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

  def total_time
    sec = (self[:total_time] * 3600).to_i
    min, sec = sec.divmod(60)
    hour, min = min.divmod(60)
    "%02d:%02d" % [hour, min]
  end

  def update_total_time
    total_time = 0.0
    self.time_logs.each do |time_log|
      checkout = time_log.checkout.try(:to_time)
      checkin = time_log.checkin.try(:to_time)
      total_time += ((checkout - checkin)/1.hour).round(2) if checkout.present? && checkin.present?
    end

    self.update_column(:total_time, total_time)
  end
end
