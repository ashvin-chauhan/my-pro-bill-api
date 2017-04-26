class ClientServicesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_service, only: [:show, :destroy,:update]


  def index
    json_response({
      success: true,
      data: {
        client_services: @client.client_services
      }
    }, 200)
  end

  def create
    @resource = @client.client_services.new(resource_params)
    super
  end

  private

  def get_service
    @resource = @client.client_services.find(params[:id])
  end
end
