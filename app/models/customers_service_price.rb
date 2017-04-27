class CustomersServicePrice < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :client_service
  belongs_to :customer, class_name: "User",foreign_key: "customer_id"

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
