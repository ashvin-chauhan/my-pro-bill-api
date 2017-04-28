class ServiceTicketItem < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :service_ticket
  belongs_to :client_service

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
