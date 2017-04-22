class InvoicesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_service_ticket, except: [:index, :search, :process_invoice]

  # GET /clients/:user_id/invoices
  def index
    invoices = @client.client_invoices.joins(service_ticket: :service_ticket_items).includes(:customer, service_ticket: [:service_ticket_items, :client]).group(:id).select("SUM(service_ticket_items.cost) as amount, invoices.id, invoices.service_ticket_id, invoices.invoice_number, invoices.status, invoices.customer_id")
    invoices = invoices.where("invoices.id IN (?)", JSON.parse(params[:invoice_ids])) if params[:invoice_ids]

    statuswise_amount = @client.client_invoices.joins(service_ticket: :service_ticket_items).group(:status).sum('service_ticket_items.cost')

    render json: {
      total_paid: statuswise_amount['paid'] || 0.0,
      total_unpaid: statuswise_amount['unpaid'] || 0.0,
      total_overdue: statuswise_amount['overdue'] || 0.0,
      total_unsent: statuswise_amount['unsent'] || 0.0,
      total_sent: statuswise_amount['sent'] || 0.0,
      invoices: array_serializer.new(invoices, serializer: CustomerInvoicesAttributesSerializer, customer: true, service: params[:with_service_details])
      }, status: 200
  end

  def class_search_params
    params[:date_range] = eval(params[:date_range]) if params[:date_range].present?
    params.permit(:customer_id, :date_range => [:start_date, :end_date])
  end

  # GET /clients/:user_id/invoices/search
  def search
    invoices = @client.client_invoices.filter(class_search_params)

    if params[:status].present?
      invoices = invoices.where(status: params[:status])
    end

    render json: array_serializer.new(invoices.includes(:customer, service_ticket: :service_ticket_items), serializer: CustomerInvoicesAttributesSerializer, customer: true), status: 200
  end

  # GET /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def show
    render json: @service_ticket.invoice, include: ['service_ticket'], except: [:service_ticket_id], status: 200
  end

  # PUT /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def update
    status_param = params[:invoice][:status]
    invoice = Invoice.where(service_ticket_id: @service_ticket)

    if status_param == "sent" || status_param == "paid"
      if status_param == "sent"
        if !invoice.first.sent?
          response = ProcessInvoice.new(invoice, current_resource_owner).send
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

    response = ProcessInvoice.new(invoices, current_resource_owner).send
    process_invoice_response(response)
  end

  private

  def get_service_ticket
    @service_ticket = @client.service_tickets.find(params[:service_ticket_id])
  end

  def process_invoice_response(response)
    if response.success?
      render json: { message: response.message }, status: response.status
    else
      render json: { errors: response.message }, status: response.status
    end
  end
end
