class ServiceTicketAttributesSerializer < ActiveModel::Serializer
  attributes :id, :service_creation_date, :note, :has_next_visit, :customer_id,
             :status, :client_id
  has_many :service_ticket_items, key: 'service_ticket_items_attributes'
  has_many :created_by
  has_many :customer

  def service_creation_date
    object.try(:service_creation_date).try(:strftime, "%m/%d/%Y")
  end
end
