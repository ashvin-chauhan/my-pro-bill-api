class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:update_password]
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
  
  # PATCH  /users/update_password
  def update_password
    @user = User.find(params[:user][:id])
    if @user.update_with_password(user_params)
      render json: {message: "Password updated successfully"}, status: :ok
    else
      render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:current_password,:password, :password_confirmation)
  end

end
