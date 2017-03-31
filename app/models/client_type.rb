class ClientType < ApplicationRecord
	validates :client_type_name, presence: true
	has_many  :user_client_types, dependent: :destroy
	has_many  :users , through: :user_client_types
end
