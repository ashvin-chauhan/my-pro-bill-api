class ServicesController < ApplicationController
  include InheritAction
  before_action :get_client_type, only: [:create]

  # POST  /client_types/:client_type_id/services
  def create
    @resource = @client_type.services.new(resource_params)
    super
  end

  private

  def get_client_type
    @client_type = ClientType.find(params[:client_type_id])
  end
end
