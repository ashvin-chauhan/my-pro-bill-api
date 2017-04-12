class ServiceTicketsController < ApplicationController
  include InheritAction
  before_action :get_client

  # POST /clients/:user_id/service_tickets
  def create
    service_ticket = ServiceTicket.new(service_ticket_params)
    service_ticket.save!

    render json: service_ticket, include: ['service_ticket_items'], status: 201
  end

  private

  def service_ticket_params
    params.require(:service_ticket)
      .permit(
        :customer_id, :service_creation_date, :note, :has_next_visit,
        service_ticket_items_attributes: [
          :id, :client_service_id, :description, :qty_hrs, :rate, :tax_rate,
          :cost, allow_destroy: true
        ]
      )
  end
end
