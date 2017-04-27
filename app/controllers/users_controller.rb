class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:update_password, :subdomain_exist]
  include InheritAction
  before_action :get_client, only: [:customers, :client_users, :invoices, :dashboard]
  before_action :get_customer, only: [:invoices]

  # GET /subdomain_exist
  def subdomain_exist
    unless params[:subdomain].present?
      json_response({
        success: false,
        message: "Invalid parameters",
        errors: [
          {
            detail: "Please supply subdomain"
          }
        ]
      }, 400) and return
    end

    client = User.all_clients.find_by(subdomain: params[:subdomain])
    if client.present?
      json_response({
        success: true,
        data: {
          client: client
        }
      }, 200)
    else
      json_response({
        success: true,
        message: "Record not found",
        errors: [
          {
            detail: 'Client with this subdomain is not exist'
          }
        ]
      }, 404)
    end
  end

  # GET  /clients
  def clients
    clients = User.all_clients

    json_response({
      success: true,
      data: {
        clients: clients.as_json(include: [:client_types])
      }
    }, 200)
  end

  # GET  /clients/:user_id/customers
  def customers
    json_response({
      success: true,
      data: {
        customers: array_serializer.new(@client.customers, serializer: Users::ClientCustomersAttributesSerializer, roles: false)
      }
    }, 200)
  end

  # GET  /clients/:user_id/users
  def client_users
    json_response({
      success: true,
      data: {
        users: @client.workers.as_json(include: [:roles], :except => [:username, :company, :subdomain])
      }
    }, 200)
  end

  # GET  /users/:id
  def show
    if @resource.client?
      json_response({
        success: true,
        data: {
          client: @resource.as_json(include: [:roles, :client_types])
        }
      }, 200)
    elsif @resource.customer?
      json_response({
        success: true,
        data: {
          customer: Users::ClientCustomersAttributesSerializer.new(@resource, roles: true)
        }
      }, 200)
    elsif @resource.worker? || @resource.sub_admin?
      json_response({
        success: true,
        data: {
          user: @resource.as_json(include: [:roles], :except => [:username, :company, :subdomain])
        }
      }, 200)
    end
  end

  # PATCH  /users/update_password
  def update_password
    @user = User.find(params[:id])
    if @user.update_with_password(user_params)
      json_response({
        success: true,
        message: "Password updated successfully"
      }, 201)
    else
      json_response({
        success: false,
        message: "Validation Failed",
        errors: ValidationErrorsSerializer.new(@user).serialize
      }, 422)
    end
  end

  # GET /clients/:user_id/customers/:customer_id/invoices
  def invoices
    json_response({
      success: true,
      data: {
        customer: Invoices::InvoiceCustomerAttributesSerializer.new(@customer)
      }
    }, 200)
  end

  # GET /clients/:user_id/dashboard_details
  def dashboard
    response = ClientDashboardDetail.new(@client).call

    json_response({
      success: true,
      data: {
        dashboard_details: response
      }
    }, 200)
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
