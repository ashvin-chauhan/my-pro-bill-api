class InvoiceServiceTicketAttributesSerializer < ActiveModel::Serializer
  attributes :id, :note, :has_next_visit, :status
  has_many :service_ticket_items
end
