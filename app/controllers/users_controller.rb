class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:update_password]
  include InheritAction
  before_action :get_user, only: [:service_clone]

  # GET  /clients
  def clients
    clients = User.clients
    render json: clients, include: ['client_types'], status: 200
  end

  # GET  /workers
  def workers
    workers = User.workers
    render json: workers, status: 200
  end

  # GET  /customers
  def customers
    customers = User.customers
    render json: customers, include: ['customer', 'clients', 'customers_service_prices'], :except => [:username, :company, :subdomain], status: 200
  end

  # GET  /users/:id
  def show
    if @resource.client?
      render json: @resource, include: ['roles', 'client_types'], status: 200
    elsif @resource.customer?
      render json: @resource, include: ['customer', 'roles', 'clients', 'customers_service_prices'], :except => [:username, :company, :subdomain], status: 200
    end
  end

  # PATCH  /users/update_password
  def update_password
    @user = User.find(params[:user][:id])
    if @user.update_with_password(user_params)
      render json: {message: "Password updated successfully"}, status: 201
    else
      render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
    end
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

  def user_params
    params.require(:user).permit(:current_password,:password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end

end
