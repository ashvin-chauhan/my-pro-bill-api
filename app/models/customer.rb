class Customer < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :user

  enum billing_period: {
    "weekly": 0,
    "biweekly": 1,
    "monthly": 2,
    "fixed": 3
  }, _suffix: true

  # billing_preference: 1. Email || email 2. Postal Service || postal_service
  # service_notifications: 1. Email || email 2. Text || text
  # should_print_invoice: true/false
  # has_email_invoice: true/false

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
