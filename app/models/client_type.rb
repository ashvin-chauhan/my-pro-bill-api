class ClientType < ApplicationRecord
	validates :client_type_name, presence: true
end
