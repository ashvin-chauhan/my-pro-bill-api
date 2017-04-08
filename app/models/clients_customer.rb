class ClientsCustomer < ApplicationRecord
  acts_as_paranoid
  belongs_to :customer_client, :class_name => "User", :foreign_key => "client_id"
  belongs_to :customer, :class_name => "User", :foreign_key => "customer_id"
end
