class ClientServicesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_service, only: [:show, :destroy,:update]


  def index
  	render json: @client.client_services
  end

  def create
    @resource = @client.client_services.new(resource_params)
    super
  end	

  def update
    super
  end	

  def show
    render json: @resource, status: 200
  end

  def destroy
    @resource.destroy!

    head 200
  end

  private

  def get_service
    @resource = @client.client_services.find(params[:id])
  end
end
