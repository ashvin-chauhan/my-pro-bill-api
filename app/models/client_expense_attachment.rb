class ClientExpenseAttachment < ApplicationRecord
  # Associations
  belongs_to :client_expense

  # Validations
  has_attached_file :expense_file
  validates_attachment_content_type :expense_file, :content_type  => ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", 'application/msword','application/pdf', /\Aimage\/.*\Z/ ], message: "Only Excel, Doc, PDF, Image files are allowed"
end
