class ExpenseCategory < ApplicationRecord
  acts_as_paranoid
	belongs_to :client, class_name: 'User', foreign_key: 'client_id'
	has_many :client_expenses
end
