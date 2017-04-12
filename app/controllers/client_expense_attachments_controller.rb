class ClientExpenseAttachmentsController < ApplicationController
  include InheritAction
  before_action :get_expenses

  def create
    @resource = @client_expense.client_expense_attachments.new(resource_params)
    super
  end

  def destroy
    @resource = @client_expense.client_expense_attachments.find(params[:id])
    super
  end

  private
    def get_expenses
      @client_expense ||= ClientExpense.find(params[:client_expense_id])
    end
end
