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

    user = User.joins(:roles).where("name = ? OR name = ?", "Super Admin", "Client Admin").find_by(subdomain: params[:subdomain])
    if user.present?
      render json: user, status: 200
    else
      render json: { error: 'Super admin/Client with this subdomain is not exist' }, status: 404
    end
  end

  # GET  /clients
  def clients
    clients = User.all_clients
    render json: clients.includes(:client_types), include: ['client_types'], status: 200
  end

  # GET  /clients/:user_id/customers
  def customers
    data = @client.customers.includes(
        :customer, :customer_clients, :roles, customers_service_prices: :client_service
      ).filter_using_character(
        params[:character]
      ).page(
        params[:page]
      ).per(
        params[:per_page]
      )

    json_response({
      success: true,
      data: {
        customers: array_serializer.new(data, serializer: Users::ClientCustomersAttributesSerializer, roles: false)
      },
      meta: meta_attributes(data)
    }, 200)
  end

  # GET  /clients/:user_id/users
  def client_users
    users = @client.workers.page(
        params[:page]
      ).per(
        params[:per_page]
      )

    json_response({
      success: true,
      data: {
        users: users.includes(:roles).as_json(include: ['roles'], :except => [:username, :company, :subdomain])
      },
      meta: meta_attributes(users)
    }, 200)
  end

  # GET  /users/:id
  def show
    if @resource.client?
      render json: @resource, include: ['roles', 'client_types'], status: 200
    elsif @resource.customer?
      render json: @resource, serializer: Users::ClientCustomersAttributesSerializer, roles: true, status: 200
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
    render json: @customer.includes(:customer_invoices), serializer: Invoices::InvoiceCustomerAttributesSerializer, status: 200
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
