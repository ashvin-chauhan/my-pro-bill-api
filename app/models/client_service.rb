class ClientService < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :client_type
  has_many   :customers_service_prices, dependent: :destroy
  has_many :service_ticket_items, dependent: :destroy
end
