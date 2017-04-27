class ExpenseCategory < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :client, class_name: 'User'
  has_many :client_expenses, dependent: :destroy

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
