class InvoicesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_service_ticket, except: [:index, :search, :process_invoice]

  # GET /clients/:user_id/invoices
  def index
    response = InvoiceIndexAndFilter.new(@client, params, { from_index: true }).call

    json_response({
      success: true,
      data: response
    }, 200)
  end

  # GET /clients/:user_id/invoices/search
  def search
    response = InvoiceIndexAndFilter.new(@client, params, { from_search: true }).call

    json_response({
      success: true,
      data: response
    }, 200)
  end

  # GET /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def show
    json_response({
      success: true,
      data: {
        invoice: @service_ticket.invoice.as_json(
          include: [:service_ticket],
          except: [:service_ticket_id]
        )
      }
    }, 200)
  end

  # PUT /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def update
    status_param = params[:invoice][:status]
    invoice = Invoice.where(service_ticket_id: @service_ticket)

    if status_param == "sent" || status_param == "paid"
      if status_param == "sent"
        if !invoice.first.sent?
          response = ProcessInvoice.new(invoice, current_resource_owner).call
          process_invoice_response(response)
        elsif invoice.first.sent?
          already_reported and return
        end

      elsif status_param == "paid"
        invoice.first.paid!

        json_response({
          success: true,
          data: {
            invoice: invoice.first
          }
        }, 201)
      end

    else
      json_response({
        success: false,
        message: "Invalid parameters",
        errors: [
          {
            detail: "Please supply valid status"
          }
        ]
      }, 400)
    end
  end

  # POST /clients/:user_id/invoices/process
  def process_invoice
    invoices = @client.client_invoices.where("invoices.id IN (?) AND invoices.status != ?", params[:invoices][:invoice_ids], Invoice.statuses[:sent]).includes(:customer, service_ticket: :service_ticket_items)

    if invoices.empty?
      already_reported and return
    end

    response = ProcessInvoice.new(invoices, current_resource_owner).call
    process_invoice_response(response)
  end

  private

  def get_service_ticket
    @service_ticket = @client.service_tickets.find(params[:service_ticket_id])
  end

  def process_invoice_response(response)
    if response.success?
      json_response({
        success: true,
        message: response.message.to_s
      }, response.status)
    else
      json_response({
        success: false,
        message: 'Bad request',
        errors: response.message
      }, response.status)
    end
  end

  def already_reported
    json_response({
      success: false,
      message: "Already reported",
      errors: [
        {
          detail: "Invoice(s) was already sent"
        }
      ]
    }, 208)
  end
end
