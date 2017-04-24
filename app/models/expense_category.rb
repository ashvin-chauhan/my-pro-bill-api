class ExpenseCategory < ApplicationRecord
  acts_as_paranoid
  belongs_to :client, class_name: 'User'
  has_many :client_expenses, dependent: :destroy
end
