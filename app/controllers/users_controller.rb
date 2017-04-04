class UsersController < ApplicationController
  include InheritAction

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
end
