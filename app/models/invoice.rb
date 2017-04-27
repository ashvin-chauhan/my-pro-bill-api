class Invoice < ApplicationRecord
  include Filterable
  acts_as_paranoid

  # Constants
  INVOICE_FORMAT = "AAAA0000"

  # Activerecord callbacks
  after_save :update_service_ticket_status

  # Validations
  validates :invoice_number, :uniqueness => true

  # Associations
  belongs_to :service_ticket
  belongs_to :sent_by, class_name: "User"
  belongs_to :customer, class_name: "User"

  enum status: { unsent: 0, paid: 1, unpaid: 2, sent: 3, overdue: 4 }

  # Scopes
  scope :overdue_invoices, -> { joins(:service_ticket).where("service_tickets.due_date < ? AND invoices.status != ? AND invoices.status != ? ", Date.today, Invoice.statuses[:paid], Invoice.statuses[:overdue]) }
  scope :invoice_amount, -> { joins(:service_ticket => :service_ticket_items).sum('service_ticket_items.cost') }

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end

  def sent_on
    self[:sent_on].try(:strftime, "%m/%d/%Y %H:%M")
  end

  private

  # class methods
  def self.next_invoice_number
    (Invoice.count > 0 ? Invoice.last.invoice_number : Invoice::INVOICE_FORMAT).succ
  end

  def self.mark_as_overdue
    overdue_invoices.update_all(status: :overdue)
  end

  # callbacks
  def update_service_ticket_status
    if self.sent? || self.paid?
      service_ticket.processed!
    end
  end
end
