class InvoicesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_service_ticket, except: [:index, :search, :process_invoice]
  before_action :get_invoice, only: [:show, :download]

  # GET /clients/:user_id/invoices
  def index
    response = InvoiceIndexAndFilter.new(@client, params, { from_index: true }).call

    json_response({
      success: true,
      data: response[:data],
      meta: meta_attributes(response[:invoices])
    }, 200)
  end

  # GET /clients/:user_id/invoices/search
  def search
    response = InvoiceIndexAndFilter.new(@client, params, { from_search: true }).call

    json_response({
      success: true,
      data: response[:data],
      meta: meta_attributes(response[:invoices])
    }, 200)
  end

  # GET /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def show
    render json: @invoice, include: ['service_ticket'], except: [:service_ticket_id], status: 200
  end

  # PUT /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def update
    status_param = params[:invoice][:status]
    invoice = Invoice.where(service_ticket_id: @service_ticket, id: params[:id])

    if status_param == "sent" || status_param == "paid"
      if status_param == "sent"
        if !invoice.first.sent?
          response = ProcessInvoice.new(invoice, current_resource_owner).call
          process_invoice_response(response)
        elsif invoice.first.sent?
          render json: { error: "Invoice is already sent" }, status: 208 and return
        end

      elsif status_param == "paid"
        invoice.first.paid!
        render json: invoice.first, status: 201
      end

    else
      render json: { error: "Please supply valid status" }, status: 404
    end
  end

  # POST /clients/:user_id/invoices/process
  def process_invoice
    invoices = @client.client_invoices.where("invoices.id IN (?) AND invoices.status != ?", params[:invoices][:invoice_ids], Invoice.statuses[:sent]).includes(:customer, service_ticket: :service_ticket_items)

    if invoices.empty?
      render json: { message: "Invoice(s) are already sent" }, status: 208 and return
    end

    response = ProcessInvoice.new(invoices, current_resource_owner).call
    process_invoice_response(response)
  end

  # GET /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id/download
  def download
    path = CommonService.invoice_pdf_exist!(@invoice)
    if path.success?
      pdf = File.read(path.data)
    else
      pdf = PdfGenerator.new({action: 'invoices', view: 'process_invoice', resource: @invoice}).call
    end

    send_data pdf, :disposition => 'inline', :type => 'application/pdf'
  end

  private

  def get_service_ticket
    @service_ticket = @client.service_tickets.find(params[:service_ticket_id])
  end

  def get_invoice
    @invoice = Invoice.where(service_ticket_id: @service_ticket).find(params[:id])
  end

  def process_invoice_response(response)
    if response.success?
      render json: { message: response.message }, status: response.status
    else
      render json: { errors: response.message }, status: response.status
    end
  end
end
