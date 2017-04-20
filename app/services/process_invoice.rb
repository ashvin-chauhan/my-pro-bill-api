class ProcessInvoice < BaseService
  attr_accessor :invoices, :return_hash, :user
  def initialize(invoices, user)
    @invoices = invoices
    @user = user
    @return_hash = []
    create_temp_table
  end

  def send
    process_invoice

    check_for_errors
  end

  private

  # Create temporary table to store failed invoices errors
  def create_temp_table
    CommonService.create_invoice_temp_table
  end

  # Destroy temporary table
  def destroy_temp_table
    Temping.teardown
  end

  def process_invoice
    invoices.each do |invoice|
      send_invoice_notification(invoice)
    end
  end

  def send_invoice_notification(invoice)
    # Check billing notification preferences
    billing_preferences = invoice.customer.customer.billing_notifications rescue {}

    if (billing_preferences & ["Email", "email"]).present?
      # Send email billing notification
      ServiceTicketMailer.send_invoice(invoice, user).deliver
    end
  end

  ####
  # Check invoices errors from temporary table `InvoiceError` and render those errors if any
  ####
  def check_for_errors
    if InvoiceError.count > 0
      InvoiceError.all.each do |invoice_error|
        return_hash << { invoice_id: invoice_error.invoice_id, error: invoice_error.error_detail }
      end
      destroy_temp_table
      Error.new(nil, return_hash, 400)
    else
      destroy_temp_table
      Success.new(nil, "Invoice(s) have been successfully sent to corresponding Customer(s).", 200)
    end
  end
end