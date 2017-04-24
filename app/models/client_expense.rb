class ClientExpense < ApplicationRecord
	acts_as_paranoid

  # Associations
	belongs_to :expense_category
	belongs_to :client, class_name: 'User'
	has_many :client_expense_attachments

  # Nested attributes
  accepts_nested_attributes_for :client_expense_attachments, allow_destroy: true

  # Validations
	validates :expense_name, length: { maximum: 50 }
	validates :vendor_name, length: { maximum: 30 }
	validates :description, length: { maximum: 100 }
end
