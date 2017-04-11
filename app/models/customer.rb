class Customer < ApplicationRecord
  acts_as_paranoid
  belongs_to :user

  enum billing_period: {
    "weekly": 0,
    "by_weekly": 1,
    "monthly": 2,
    "fixed": 3
  }, _suffix: true

end
