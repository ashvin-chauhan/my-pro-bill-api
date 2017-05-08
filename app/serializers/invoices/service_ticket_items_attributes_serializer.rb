class Invoices::ServiceTicketItemsAttributesSerializer < ActiveModel::Serializer
  attributes :id, :description, :qty_hrs, :rate, :tax_rate, :cost, :client_service_name

  def client_service_name
    object.client_service&.service_name
  end
end
