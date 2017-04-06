class ClientsCustomer < ApplicationRecord
  belongs_to :client, :class_name => "User", :foreign_key => "client_id"
  belongs_to :customer, :class_name => "User", :foreign_key => "customer_id"
end
