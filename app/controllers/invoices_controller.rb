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

    if invoices.count > 0
      render json: array_serializer.new(invoices.includes(:customer, service_ticket: :service_ticket_items), serializer: CustomerInvoicesAttributesSerializer, customer: true), status: 200
    else
      render json: { error: "No results found" }, status: 404
    end
  end

  # GET /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def show
    render json: @service_ticket.invoice, include: ['service_ticket'], except: [:service_ticket_id], status: 200
  end

  # PUT /clients/:user_id/service_tickets/:service_ticket_id/invoices/:id
  def update
    status_param = params[:invoice][:status]
    invoice = @service_ticket.invoice

    if status_param == "sent" || status_param == "paid"
      invoice.update_attributes!(status: status_param)

      render json: invoice, status: 201
    else
      render json: { error: "please supply valid status" }, status: 404
    end
  end

  # POST /clients/:user_id/invoices/process
  def process_invoice
    invoices = @client.client_invoices.where("invoices.id IN (?) AND invoices.status != ?", params[:invoices][:invoice_ids], Invoice.statuses[:sent]).includes(:customer, service_ticket: :service_ticket_items)

    if invoices.empty?
      render json: { message: "Invoices are already sent" }, status: 208 and return
    end

    CommonService.create_invoice_temp_table

    invoices.each do |invoice|
      # Check billing notification preferences
      billing_preferences = invoice.customer.customer.billing_notifications rescue {}

      if (billing_preferences & ["Email", "email"]).present?
        # Send email billing notification
        ServiceTicketMailer.send_invoice(invoice, current_resource_owner).deliver
      end
    end

    if InvoiceError.count > 0
      return_hash = []
      InvoiceError.all.each do |invoice_error|
        return_hash << { invoice_id: invoice_error.invoice_id, error: invoice_error.error_detail }
      end
      render json: { errors: return_hash }, status: 400
    else
      render json: { message: "Invoice(s) have been successfully sent to corresponding Customer(s)." }, status: 200
    end

    Temping.teardown
  end

  private

  def get_service_ticket
    @service_ticket = @client.service_tickets.find(params[:service_ticket_id])
  end
end
