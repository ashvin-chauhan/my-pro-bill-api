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
        "COALESCE(SUM(amount), 0.0) as total_expenses,
        COUNT(*) as number_of_expenses"
      )
    end

    def invoices
      client.client_invoices.filter(
        invoice_search_params
      ).joins(
        service_ticket: :service_ticket_items
      ).select(
        "COALESCE(SUM(service_ticket_items.cost), 0.0) as total_amount,
        COUNT(DISTINCT invoices.id) as number_of_invoices,
        COUNT(DISTINCT invoices.customer_id) as number_of_customers"
      )
    end

    def payments
      client.client_invoices.paid.filter(
        invoice_search_params
      ).joins(
        service_ticket: :service_ticket_items
      ).select(
        "COALESCE(SUM(service_ticket_items.cost), 0.0) as total_amount,
        COUNT(DISTINCT invoices.id) as number_of_invoices,
        COUNT(DISTINCT invoices.customer_id) as number_of_customers"
      )
    end

    def overdues
      client.client_invoices.overdue.filter(
        invoice_search_params
      ).joins(
        service_ticket: :service_ticket_items
      ).select(
        "COALESCE(SUM(service_ticket_items.cost), 0.0) as total_amount,
        COUNT(DISTINCT invoices.id) as number_of_invoices,
        COUNT(DISTINCT invoices.customer_id) as number_of_customers"
      )
    end

    def times
      client.time_trackers.filter(
        time_search_params
      ).select(
        "COALESCE(SUM(time_trackers.total_time), 00.00) as total_time,
        COUNT(DISTINCT worker_id) as number_of_workers"
      )
    end

    def expense_search_params
      params.permit(:date_range => [:start_date, :end_date])
    end

    def invoice_search_params
      params.permit(:customer_id, :date_range => [:start_date, :end_date])
    end

    def time_search_params
      params.permit(:worker_id, :date_range => [:start_date, :end_date])
    end

    def return_hash
      {
        expenses: expenses[0],
        invoices: invoices[0],
        payments: payments[0],
        times: times[0]
      }
    end
  end
end