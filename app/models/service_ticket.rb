class ServiceTicket < ApplicationRecord
  acts_as_paranoid
  belongs_to :customer, :class_name => "User"
  belongs_to :created_by, :class_name => "User"
  belongs_to :client, :class_name => "User"
  has_many :service_ticket_items, dependent: :destroy
  accepts_nested_attributes_for :service_ticket_items, allow_destroy: true

  enum status: { unprocessed: 0 }
end
