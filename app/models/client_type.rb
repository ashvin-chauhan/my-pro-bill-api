class ClientType < ApplicationRecord
  acts_as_paranoid

  # Associations
  validates :client_type_name, presence: true
  has_many  :users_client_types, dependent: :destroy
  has_many  :users , through: :users_client_types
  has_many  :services, dependent: :destroy
  has_many  :client_services, dependent: :destroy

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
