class ServiceTicketMailer < ApplicationMailer
  # require 'open-uri'
  def notify_customer(service_ticket,customer,client)
    @service_ticket = service_ticket
    @customer = customer
    @client = client
    # @service_ticket.service_ticket_attachments.each do |service_ticket_attachment|
    #   if service_ticket_attachment.file.present?
    #     attachments[service_ticket_attachment.file_file_name] = open("#{service_ticket_attachment.file.expiring_url(60)}").read
    #   end
    # end
    mail(to: @client.email, subject: 'Service Created Notification')
  end

  def send_invoice(invoice, user)
    ActiveRecord::Base.transaction do
      begin
        @invoice = invoice
        @customer = invoice.customer
        @service_ticket = invoice.service_ticket

        # Call pdf generator service for generate pdf and save in public directory
        pdf = PdfGenerator.new({action: 'invoices', view: 'process_invoice', resource: @invoice}).call

        attachments['invoice.pdf'] = pdf
        mail(to: @customer.try(:email), subject: "Invoice")
        @invoice.update_attributes!(status: 'sent', sent_by_id: user.id, sent_on: Date.current)
      rescue Exception => e
        @error = e
        raise ActiveRecord::Rollback
      end
    end

    InvoiceError.create(invoice_id: invoice.id, error_detail: @error.message) if @error.present?
  end
end
