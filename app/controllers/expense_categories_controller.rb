class ExpenseCategoriesController < ApplicationController
	include InheritAction
  before_action :get_client
  
  def create 
    @resource = @client.expense_categories.new(resource_params)
    super
  end

  def update
    @resource = @client.expense_categories.find(params[:id])
    super
  end

  private

  def get_client
    @client ||= User.find(params[:user_id])
  end
end
