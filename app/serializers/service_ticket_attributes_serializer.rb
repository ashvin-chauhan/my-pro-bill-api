class ServiceTicketAttributesSerializer < ActiveModel::Serializer
  attributes :id, :service_creation_date, :due_date, :note, :has_next_visit, :customer_id,
             :status, :client_id
  has_many :service_ticket_items, key: 'service_ticket_items_attributes'
  has_many :service_ticket_attachments, key: "service_ticket_attachments_attributes", serializer: ServiceTicketAttachmentAttrSerializer
  has_many :created_by
  has_many :customer

  def service_creation_date
    object.try(:service_creation_date).try(:strftime, "%m/%d/%Y")
  end

  def due_date
    object.try(:due_date).try(:strftime, "%m/%d/%Y")
  end
end
