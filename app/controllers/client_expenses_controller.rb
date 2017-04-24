class ClientExpensesController < ApplicationController
  include InheritAction
  before_action :get_client

  # POST /clients/:user_id/client_expenses
  def create
    client_expense = @client.client_expenses.new(client_expsense_params)
    client_expense.save!

    render json: client_expense, include: ['client_expense_attachments']
  end

  def update
    @resource = @client.client_expenses.find(params[:id])
    super
  end

  private

  def client_expsense_params
    params.require(:client_expense)
      .permit(
        :expense_category_id, :expense_name, :amount, :vendor_name, :description,
        :start_mileage, :end_mileage,
        client_expense_attachments_attributes: [:id, :expense_file, allow_destroy: true]
      )
  end
end
