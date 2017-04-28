class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:update_password, :subdomain_exist]
  include InheritAction
  before_action :get_client, only: [:customers, :client_users, :invoices, :dashboard]
  before_action :get_customer, only: [:invoices]

  # GET /subdomain_exist
  def subdomain_exist
    unless params[:subdomain].present?
      render json: { error: 'Please supply subdomain' }, status: 400 and return
    end

    client = User.find_by(subdomain: params[:subdomain])
    if client.present?
      render json: client, status: 200
    else
      render json: { error: 'Client with this subdomain is not exist' }, status: 404
    end
  end

  # GET  /clients
  def clients
    clients = User.all_clients
    render json: clients, include: ['client_types'], status: 200
  end

  # GET  /clients/:user_id/customers
  def customers
    render json: array_serializer.new(@client.customers, serializer: Users::ClientCustomersAttributesSerializer, roles: false), status: 200
  end

  # GET  /clients/:user_id/users
  def client_users
    render json: @client.workers, include: ['roles'], :except => [:username, :company, :subdomain], status: 200
  end

  # GET  /users/:id
  def show
    if @resource.client?
      render json: @resource, include: ['roles', 'client_types'], status: 200
    elsif @resource.customer?
      render json: @resource, serializer: ClientCustomersAttributesSerializer, roles: true, status: 200
    elsif @resource.worker? || @resource.sub_admin?
      render json: @resource, include: ['roles'], :except => [:username, :company, :subdomain], status: 200
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

  # GET /clients/:user_id/customers/:customer_id/invoices
  def invoices
    render json: @customer, serializer: Invoices::InvoiceCustomerAttributesSerializer, status: 200
  end

  # GET /clients/:user_id/dashboard_details
  def dashboard
    response = ClientDashboardDetail.new(@client).call
    render json: response, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:current_password,:password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end

  def get_customer
    @customer = @client.customers.find(params[:customer_id])
  end

end
