class Users::CustomerServicePricesAttributesSerializer < ActiveModel::Serializer
  attributes :id, :price, :service_name

  def service_name
    object.client_service.try(:service_name)
  end
end
