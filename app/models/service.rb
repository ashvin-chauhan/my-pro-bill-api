class Service < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :client_type

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
