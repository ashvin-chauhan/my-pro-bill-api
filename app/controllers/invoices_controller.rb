class InvoicesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_service_ticket, except: [:index, :search]

  # GET /clients/:user_id/invoices
  def index
    render json: array_serializer.new(@client.client_invoices.includes(:customer, service_ticket: :service_ticket_items), serializer: CustomerInvoicesAttributesSerializer, customer: true), status: 200
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

  private

  def get_service_ticket
    @service_ticket = @client.service_tickets.find(params[:service_ticket_id])
  end
end
