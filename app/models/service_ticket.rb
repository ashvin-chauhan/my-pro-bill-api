class ServiceTicket < ApplicationRecord
  acts_as_paranoid

  # Activerecord callbacks
  before_save :set_duedate
  after_create_commit :create_invoice
  after_create_commit :send_notification, only: [:create]

  # Associations
  belongs_to :customer, class_name: "User"
  belongs_to :created_by, class_name: "User"
  belongs_to :client, class_name: "User"
  has_many :service_ticket_items, dependent: :destroy
  has_many :service_ticket_attachments, dependent: :destroy
  has_one :invoice, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :service_ticket_items, allow_destroy: true
  accepts_nested_attributes_for :service_ticket_attachments, allow_destroy: true

  enum status: { unprocessed: 0, processed: 1 }

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end

  def service_creation_date
    self[:service_creation_date].to_s
  end

  def due_date
    self[:due_date].to_s
  end

  private

  # Callbacks
  def set_duedate
    self.due_date = parse_date(service_creation_date) + 30.days if service_creation_date.present?
  end

  def create_invoice
    invoice = self.build_invoice(customer_id: self.customer_id, invoice_number: Invoice.next_invoice_number)
    invoice.save!

    PdfGenerator.new({action: 'invoices', view: 'process_invoice', resource: invoice}).call
  end
  handle_asynchronously :create_invoice

  # Send notification via mail and/or text to customer
  def send_notification
    service_notifications = self.customer.customer.service_notifications.map {|st| st&.downcase }
    if service_notifications.include? ("email") and service_notifications.include?("text")
      ServiceTicketMailer.notify_customer(self, self.customer, self.client).deliver
    elsif service_notifications.include? 'email'
      # integrate EMAIL API
      ServiceTicketMailer.notify_customer(self, self.customer, self.client).deliver
    elsif service_notifications.include? 'text'
      # integrate SMS API
    end
  end
  handle_asynchronously :send_notification
end
