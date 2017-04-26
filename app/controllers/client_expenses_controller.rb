class ClientExpensesController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_client_expense, only: [:show, :update, :destroy]

  # GET /clients/:user_id/client_expenses
  def index
    client_expenses = @client.client_expenses

    json_response({
      success: true,
      data: {
        client_expenses: array_serializer.new(client_expenses, serializer: ClientExpenses::ClientExpenseAttributesSerializer)
      }
    }, 200)
  end

  # POST /clients/:user_id/client_expenses
  def create
    client_expense = @client.client_expenses.new(client_expsense_params)
    client_expense.created_by_id = current_resource_owner.id
    client_expense.save!

    json_response({
      success: true,
      data: {
        client_expense: ClientExpenses::ClientExpenseAttributesSerializer.new(client_expense)
      }
    }, 201)
  end

  # GET /clients/:user_id/client_expenses/:id
  def show
    json_response({
      success: true,
      data: {
        client_expense: ClientExpenses::ClientExpenseAttributesSerializer.new(@client_expense, attachment: true, category: true)
      }
    }, 200)
  end

  # PUT /clients/:user_id/client_expenses/:id
  def update
    @client_expense.update_attributes(client_expsense_params)

    json_response({
      success: true,
      data: {
        client_expense: ClientExpenses::ClientExpenseAttributesSerializer.new(@client_expense)
      }
    }, 200)
  end

  # DELETE /clients/:user_id/tasks/:id
  def destroy
    @resource = @client_expense
    super
  end

  private

  def client_expsense_params
    params.require(:client_expense)
      .permit(
        :expense_category_id, :expense_name, :amount, :vendor_name, :description,
        :start_mileage, :end_mileage, :expense_date, :status,
        client_expense_attachments_attributes: [:id, :expense_file, :_destroy]
      )
  end

  def get_client_expense
    @client_expense = @client.client_expenses.find(params[:id])
  end
end
