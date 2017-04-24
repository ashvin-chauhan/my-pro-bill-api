class Invoices::InvoiceCustomerAttributesSerializer < ActiveModel::Serializer
  attributes :full_name, :phone, :email, :total_paid, :total_unpaid, :total_overdue, :total_unsent
  has_many :customer_invoices, key: "invoices", serializer: Invoices::CustomerInvoicesAttributesSerializer

  def total_paid
    Invoice.paid.invoice_amount
  end

  def total_unpaid
    Invoice.unpaid.invoice_amount
  end

  def total_overdue
    Invoice.overdue.invoice_amount
  end

  def total_unsent
    Invoice.unsent.invoice_amount
  end
end
