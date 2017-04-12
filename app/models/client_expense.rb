class ClientExpense < ApplicationRecord
	acts_as_paranoid

	belongs_to :expense_category
	belongs_to :client, class_name: 'User', foreign_key: 'client_id'
	has_many :client_expense_attachments
	
	validates :expense_name, length: { maximum: 50 }
	validates :vendor_name, length: { maximum: 30 }
	validates :description, length: { maximum: 100 }
end
