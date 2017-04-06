class ClientServicesController < ApplicationController
	include InheritAction
  before_action :get_user, only: [:create]
  
  def create 
    @resource = @user.client_services.new(resource_params)
    super
  end

  private

  def get_user
    @user ||= User.find(params[:user_id])
  end
end
