class ServicesController < ApplicationController
  include InheritAction
  before_action :get_client_type, only: [:create]

  # POST  /services
  def create
    @resource = @client_type.services.new(resource_params)
    super
  end

  # GET /services
  def index
    resource = resource_class.includes(:client_type)
    render json: resource, include: ['client_type'], status: :ok
  end

  private

  def get_client_type
    @client_type = ClientType.find(params[:service][:client_type_id])
  end
end
