class CustomersServicePrice < ApplicationRecord
  acts_as_paranoid
  belongs_to :client_service
  belongs_to :customer, :class_name => "User", :foreign_key => "customer_id"
end
