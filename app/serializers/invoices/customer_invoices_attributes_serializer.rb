class Invoices::CustomerInvoicesAttributesSerializer < ActiveModel::Serializer
  attributes :id, :service_ticket_id, :invoice_number, :status, :amount, :generation_date, :due_date
  attribute :customer, :if => Proc.new { instance_options[:customer] }
  attribute :company_name, :if => Proc.new { instance_options[:service] == "true" }
  has_many :service_ticket, serializer: Invoices::InvoiceServiceTicketAttributesSerializer, :if => Proc.new { instance_options[:service] == "true" }

  def generation_date
    object.service_ticket.try(:service_creation_date)
  end

  def due_date
    object.service_ticket.try(:due_date)
  end

  def amount
    object['amount']
  end

  def customer
    {
      full_name: object.customer.full_name,
      phone: object.customer.try(:phone),
      email: object.customer.try(:email)
    }
  end

  def company_name
    object.service_ticket.client.try(:company)
  end
end
