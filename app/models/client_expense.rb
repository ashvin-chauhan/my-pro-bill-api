class ClientExpense < ApplicationRecord
  include Filterable
  acts_as_paranoid

  # Associations
  belongs_to :expense_category
  belongs_to :client, class_name: 'User'
  belongs_to :created_by, class_name: 'User'
  has_many :client_expense_attachments, dependent: :destroy

  enum status: { remaining: 0, completed: 1 }

  # Nested attributes
  accepts_nested_attributes_for :client_expense_attachments, allow_destroy: true

  # Validations
  validates :expense_name, length: { maximum: 50 }
  validates :vendor_name, length: { maximum: 30 }
  validates :description, length: { maximum: 100 }

  # Getter methods
  def expense_date
    self[:expense_date].to_s
  end

  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
