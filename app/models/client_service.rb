class ClientService < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :user
  belongs_to :client_type
  has_many   :customers_service_prices, dependent: :destroy
  has_many :service_ticket_items, dependent: :destroy

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
