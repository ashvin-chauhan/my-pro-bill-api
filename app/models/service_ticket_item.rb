class ServiceTicketItem < ApplicationRecord
  acts_as_paranoid
  belongs_to :service_ticket
  belongs_to :client_service
end
