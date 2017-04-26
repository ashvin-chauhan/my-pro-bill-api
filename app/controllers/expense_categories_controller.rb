class ExpenseCategoriesController < ApplicationController
  include InheritAction
  before_action :get_client

  # POST /clients/:user_id/expense_categories
  def create
    @resource = @client.expense_categories.new(resource_params)
    super
  end

  # PATCH /clients/:user_id/expense_categories/:id
  def update
    @resource = @client.expense_categories.find(params[:id])
    super
  end
end
