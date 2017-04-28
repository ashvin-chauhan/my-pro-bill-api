class ServiceTickets::ServiceTicketAttributesSerializer < ActiveModel::Serializer
  attributes :id, :service_creation_date, :due_date, :note, :has_next_visit, :customer_id,
             :status, :client_id
  has_many :service_ticket_items, key: 'service_ticket_items_attributes'
  has_many :service_ticket_attachments, key: "service_ticket_attachments_attributes", serializer: ServiceTickets::ServiceTicketAttachmentAttrSerializer
  has_many :created_by
  has_many :customer
end
