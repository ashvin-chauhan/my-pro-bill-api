class ClientService < ApplicationRecord
  belongs_to :user
  belongs_to :client_type
  has_many   :customers_service_prices, dependent: :destroy
end
