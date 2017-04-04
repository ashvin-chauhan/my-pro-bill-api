class UsersController < ApplicationController
  include InheritAction
  before_action :get_user, only: [:service_clone]

	# GET  /clients
  def clients
  	clients = User.clients
  	render json: clients, status: 200
  end

  # GET  /workers
  def workers
  	workers = User.workers
  	render json: workers, status: 200
  end

  # GET  /customers
  def customers
  	customers = User.customers
  	render json: customers, status: 200
  end

  # GET  /users/:id
  def show
    render json: @resource, include: ['roles', 'client_types'], status: 200
  end

  # POST  /users/:id/service_clone
  def service_clone
    if @user.client_services.count > 0
      render json: { error: 'Services are already cloned' }, status: 208
    else
      client_services = @user.client_services.create(@user.services.select(:service_name, :client_type_id).map(&:attributes))
      render json: @user, include: ['client_services'], status: 201
    end
  end

  private

  def get_user
    @user = User.find(params[:id])
  end
end
