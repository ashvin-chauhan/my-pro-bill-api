class ServiceTicketsController < ApplicationController
  include InheritAction
  before_action :get_client

  # POST /clients/:user_id/service_tickets
  def create
    service_ticket = @client.service_tickets.new(service_ticket_params)
    service_ticket.created_by = current_resource_owner
    service_ticket.save!

    render json: service_ticket, serializer: ServiceTicketAttributesSerializer, status: 201
  end

  # GET /clients/:user_id/customers/:customer_id/service_tickets
  def customer_service_tickets
    service_ticket = @client.service_tickets.where(customer_id: params[:customer_id])
    render json: array_serializer.new(service_ticket, serializer: ServiceTicketAttributesSerializer), status: 200
  end

  private

  def service_ticket_params
    params.require(:service_ticket)
      .permit(
        :customer_id, :service_creation_date, :note, :has_next_visit,
        service_ticket_attachments_attributes: [:id, :file, allow_destroy: true],
        service_ticket_items_attributes: [
          :id, :client_service_id, :description, :qty_hrs, :rate, :tax_rate,
          :cost, allow_destroy: true
        ]
      )
  end
end
