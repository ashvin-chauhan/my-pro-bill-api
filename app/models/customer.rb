class Customer < ApplicationRecord
  acts_as_paranoid
  belongs_to :user

  enum billing_period: {
    "weekly": 0,
    "by_weekly": 1,
    "monthly": 2,
    "fixed": 3
  }, _suffix: true

  enum billing_notifications: {
    "email": 0,
    "postal_service": 1
  }, _suffix: true

  enum service_notifications: {
    "email": 0,
    "text": 1
  }, _suffix: true

end
