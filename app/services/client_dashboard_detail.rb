class ClientDashboardDetail
  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def call
    return_hash
  end

  private

  def total_customers
    client.customers.count
  end

  def since
    client.try(:created_at)
  end

  def snapshot
    invoices = client.client_invoices.joins(service_ticket: :service_ticket_items).group(:status).sum('service_ticket_items.cost')

    invoices = {
      "unsent": invoices['unsent'] || 0.0,
      "paid": invoices['paid'] || 0.0,
      "unpaid": invoices['unpaid'] || 0.0,
      "sent": invoices['sent'] || 0.0,
      "overdue": invoices['overdue'] || 0.0
    } if invoices.present?

    invoices
  end

  def tasks
    client.client_tasks.joins(
      "INNER JOIN users as assign_to_users ON assign_to_users.id = client_tasks.assign_to_id
       INNER JOIN users as assign_by_users ON assign_by_users.id = client_tasks.created_by_id"
    ).select(
     "client_tasks.id,
      client_tasks.task_name as task_name,
      status,
      CASE
      WHEN assign_to_users.first_name is null AND assign_to_users.last_name is null THEN null
      WHEN assign_to_users.last_name is null THEN assign_to_users.first_name
      ELSE CONCAT(assign_to_users.first_name, ' ', assign_to_users.last_name)
      END AS assign_to_full_name,
      CASE
      WHEN assign_by_users.first_name is null AND assign_by_users.last_name is null THEN null
      WHEN assign_by_users.last_name is null THEN assign_by_users.first_name
      ELSE CONCAT(assign_by_users.first_name, ' ', assign_by_users.last_name)
      END AS assign_by_full_name"
    ).last(3).reverse
  end

  def overdue_invoices
    client.client_invoices.overdue.joins(
      service_ticket: :service_ticket_items
    ).joins(
      "INNER JOIN users as customers ON customers.id = invoices.customer_id"
    ).group(
      "invoices.invoice_number,
      invoices.id, customers.first_name, customers.last_name"
    ).select(
      "invoices.id,
      invoice_number as invoice_number,
      SUM(service_ticket_items.cost) as amount,
      to_char(invoices.created_at, 'MM/DD/YYYY') as invoice_date,
      CASE
      WHEN customers.first_name is null AND customers.last_name is null THEN null
      WHEN customers.last_name is null THEN customers.first_name
      ELSE CONCAT(customers.first_name, ' ', customers.last_name)
      END AS customer_name"
    ).last(6).reverse
  end

  def return_hash
    {
      "data": {
        total_customers: total_customers,
        since: since,
        snapshot: snapshot,
        tasks: tasks,
        overdue_invoices: overdue_invoices
      }
    }
  end
end