class ClientExpenseAttachment < ApplicationRecord
	acts_as_paranoid
	has_attached_file :expense_file
	validates_attachment_content_type :expense_file, content_type: /\Aimage\/.*\z/
end
