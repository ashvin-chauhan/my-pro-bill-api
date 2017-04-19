class ServiceTicketMailer < ApplicationMailer
  def notify_customer(service_ticket,customer,client)
    @service_ticket = service_ticket
    @customer = customer
    @client = client
    mail(to: @client.email, subject: 'Service Created Notification')
  end

  def send_invoice(invoice)
    ActiveRecord::Base.transaction do
      begin
        @invoice = invoice
        @customer = invoice.customer
        @service_ticket = invoice.service_ticket

        # Call pdf generator service for generate pdf
        pdf = PdfGenerator.new({action: 'invoices', view: 'process_invoice', resource: @invoice}).send

        # Save generated pdf in public directory
        save_path = Rails.root.join('public/invoices',"invoice#{@invoice.id}.pdf")
        File.open(save_path, 'wb') do |file|
          file << pdf
        end

        attachments['invoice.pdf'] = pdf
        mail(to: @customer.try(:email), subject: "Invoice")
        @invoice.sent!
      rescue Exception => e
        @error = e
        raise ActiveRecord::Rollback
      end
    end

    InvoiceError.create(invoice_id: invoice.id, error_detail: @error.message) if @error.present?
  end
end
