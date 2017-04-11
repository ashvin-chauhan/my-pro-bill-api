class ClientServicesController < ApplicationController
  include InheritAction
  before_action :get_client, only: [:create]

  def create
    @resource = @client.client_services.new(resource_params)
    super
  end
end
