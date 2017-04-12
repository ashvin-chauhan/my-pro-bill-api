class ClientExpensesController < ApplicationController
  include InheritAction
  before_action :get_client

  def create
    @resource = @client.client_expenses.new(resource_params)
    super
  end

  def update
    @resource = @client.client_expenses.find(params[:id])
    super
  end
end
