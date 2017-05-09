module Report
  class Summary
    attr_accessor :client, :params

    def initialize(client, params = {})
      @client = client
      @params = params
      params[:date_range] = eval(params[:date_range]) if params[:date_range].present? && params[:date_range].class == String
    end

    def call
      return_hash
    end

    private

    def expenses
      client.client_expenses.filter(
        expense_search_params
      ).select(
        "SUM(amount) as total_expenses,
        COUNT(*) as number_of_expenses"
      )
    end

    def invoices
      client.client_invoices.filter(
        invoice_search_params
      ).joins(
        service_ticket: :service_ticket_items
      ).select(
        "SUM(service_ticket_items.cost) as total_amount,
        COUNT(DISTINCT invoices.id) as number_of_invoices,
        COUNT(DISTINCT invoices.customer_id) as number_of_customers"
      )
    end

    def expense_search_params
      params.permit(:date_range => [:start_date, :end_date])
    end

    def invoice_search_params
      params.permit(:customer_id, :date_range => [:start_date, :end_date])
    end

    def return_hash
      {
        expenses: expenses,
        invoices: invoices
      }
    end
  end
end