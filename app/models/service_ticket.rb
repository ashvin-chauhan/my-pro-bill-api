class ServiceTicket < ApplicationRecord
  acts_as_paranoid

  # Activerecord callbacks
  before_save :set_duedate
  after_create_commit :create_invoice

  # Associations
  belongs_to :customer, :class_name => "User"
  belongs_to :created_by, :class_name => "User"
  belongs_to :client, :class_name => "User"
  has_many :service_ticket_items, dependent: :destroy
  has_one :invoice, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :service_ticket_items, allow_destroy: true

  enum status: { unprocessed: 0, processed: 1 }

  private

  # Callbacks
  def set_duedate
    self.due_date = self.service_creation_date + 30.days
  end

  def create_invoice
    invoice = self.build_invoice(customer_id: self.customer_id, invoice_number: Invoice.next_invoice_number)
    invoice.save!
  end
end
