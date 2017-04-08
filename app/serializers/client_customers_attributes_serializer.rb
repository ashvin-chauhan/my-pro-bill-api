class ClientCustomersAttributesSerializer < ActiveModel::Serializer
  attributes :id, :email, :alternate_email, :first_name, :last_name, :phone, :alternate_phone,
             :nick_name, :address, :country, :state, :city, :zip, :active
  has_one :customer, key: 'customer_attributes'
  has_many :roles, :if => Proc.new { instance_options[:roles] }
  has_many :customer_clients
  has_many :customers_service_prices, key: 'customers_service_prices_attributes'
end
