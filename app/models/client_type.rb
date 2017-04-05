class ClientType < ApplicationRecord
  validates :client_type_name, presence: true
  has_many  :users_client_types, dependent: :destroy
  has_many  :users , through: :users_client_types
  has_many  :services, dependent: :destroy
  has_many  :client_services, dependent: :destroy
end
