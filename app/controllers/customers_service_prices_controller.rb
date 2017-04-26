class CustomersServicePricesController < ApplicationController
  before_action :get_client
  before_action :get_client_service, only: [:index]
  before_action :get_customer_service_price, only: [:index]

  # GET /clients/:user_id/client_services/:client_service_id/customers_service_prices
  def index
    @service_price = @service_price.where(customer_id: params[:customer_id]) if params[:customer_id].present?

    json_response({
      success: true,
      data: {
        customers_service_prices: @service_price
      }
    }, 200)
  end

  private

  def get_client_service
    @client_service = @client.client_services.find(params[:client_service_id])
  end

  def get_customer_service_price
    @service_price = @client_service.customers_service_prices
  end
end
