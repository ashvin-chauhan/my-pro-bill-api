class InvoiceIndexAndFilter < BaseService
  attr_accessor :client, :params, :from_index, :from_search
  def initialize(client, params = {}, options = {})
    @client = client
    @params = params
    @from_index = options[:from_index] || false
    @from_search = options[:from_search] || false
  end

  def call
    return_hash
  end

  private

  # Get client invoices
  def invoices
    client.client_invoices
  end

  # Get invoices with selected columns
  def invoice_with_selected_columns
    invoices.joins(
      service_ticket: :service_ticket_items
    ).includes(
      :customer,
      service_ticket: [:service_ticket_items, :client]
    ).group(
      :id
    ).select(
      "SUM(service_ticket_items.cost) as amount, invoices.id, invoices.service_ticket_id, invoices.invoice_number, invoices.status, invoices.customer_id, invoices.created_at"
    )
  end

  # Get invoices amount with group of status
  def statuswise_amount
    invoices.joins(
      service_ticket: :service_ticket_items
    ).group(
      :status
    ).sum(
      'service_ticket_items.cost'
    )
  end

  # Filter index invoices if invoice ids present otherwise return client all invoices
  def filter_using_invoice_ids
    invoice_with_selected_columns.where("invoices.id IN (?)", JSON.parse(params[:invoice_ids]))
  end

  # Permit parameter for search invoices
  def class_search_params
    params[:date_range] = eval(params[:date_range]) if params[:date_range].present? && params[:date_range].class == String
    params.permit(:customer_id, :date_range => [:start_date, :end_date])
  end

  # Filter invoices based on params
  def filter_using_params
    invoices = invoice_with_selected_columns.filter(class_search_params)
    if params[:status].present?
      invoices = invoices.where(status: params[:status])
    end
    invoices
  end

  # Return final invoices result
  def updated_invoices
    if from_index
      return filter_using_invoice_ids if params[:invoice_ids]
      return invoice_with_selected_columns
    elsif from_search
      filter_using_params
    end
  end

  def return_hash
    invoices = updated_invoices
    status_with_amt = statuswise_amount

    {
      total_paid: status_with_amt['paid'] || 0.0,
      total_unpaid: status_with_amt['unpaid'] || 0.0,
      total_overdue: status_with_amt['overdue'] || 0.0,
      total_unsent: status_with_amt['unsent'] || 0.0,
      total_sent: status_with_amt['sent'] || 0.0,
      invoices: ActiveModel::Serializer::CollectionSerializer.new(
        invoices, serializer: Invoices::CustomerInvoicesAttributesSerializer, customer: true, service: params[:with_service_details]
      )
    }
  end
end