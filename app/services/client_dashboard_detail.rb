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
      "unpaid": (invoices['unpaid'] || 0.0) + (invoices['sent'] || 0.0),
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

  def invoice_activity_columns(invoice)
    invoice.joins(
      service_ticket: :service_ticket_items
    ).joins(
      "INNER JOIN users as customers ON customers.id = invoices.customer_id"
    ).order(
      "invoices.updated_at DESC"
    ).group(
      "invoices.id, invoices.invoice_number, customers.first_name, customers.last_name"
    ).select(
      "invoices.id,
      invoices.invoice_number,
      invoices.status,
      CASE
      WHEN customers.first_name is null AND customers.last_name is null THEN null
      WHEN customers.last_name is null THEN customers.first_name
      ELSE CONCAT(customers.first_name, ' ', customers.last_name)
      END AS customer_name,
      SUM(service_ticket_items.cost) as amount,
      to_char(invoices.created_at, 'MM/DD/YYYY') as invoice_date"
    )
  end

  def invoices_sent
    invoice_activity_columns(client.client_invoices.unpaid.limit(1))
  end

  def payment_recieved
    invoice_activity_columns(client.client_invoices.paid.limit(1))
  end

  def service
    client.service_tickets.order(
      "service_tickets.created_at DESC"
    ).limit(1).joins(
      "INNER JOIN users as customers ON customers.id = service_tickets.customer_id"
    ).select(
      "service_tickets.id,
      CASE
      WHEN customers.first_name is null AND customers.last_name is null THEN null
      WHEN customers.last_name is null THEN customers.first_name
      ELSE CONCAT(customers.first_name, ' ', customers.last_name)
      END AS customer_name,
      to_char(service_tickets.created_at, 'MM/DD/YYYY') as service_ticket_date"
    )
  end

  def expense_created
    client.client_expenses.order(
      "client_expenses.created_at DESC"
    ).limit(1).select(
      "client_expenses.id,
      client_expenses.amount,
      to_char(client_expenses.created_at, 'MM/DD/YYYY') as client_expense_date"
    )
  end

  def task_activity_columns(task)
    task.joins(
      "INNER JOIN users as assign_to_users ON assign_to_users.id = client_tasks.assign_to_id
       INNER JOIN users as assign_by_users ON assign_by_users.id = client_tasks.created_by_id"
    ).select(
      "client_tasks.id,
      client_tasks.status,
      CASE
      WHEN assign_to_users.first_name is null AND assign_to_users.last_name is null THEN null
      WHEN assign_to_users.last_name is null THEN assign_to_users.first_name
      ELSE CONCAT(assign_to_users.first_name, ' ', assign_to_users.last_name)
      END AS assign_to_full_name,
      CASE
      WHEN assign_by_users.first_name is null AND assign_by_users.last_name is null THEN null
      WHEN assign_by_users.last_name is null THEN assign_by_users.first_name
      ELSE CONCAT(assign_by_users.first_name, ' ', assign_by_users.last_name)
      END AS assign_by_full_name,
      to_char(client_tasks.created_at, 'MM/DD/YYYY') as client_task_date"
    )
  end

  def task_created
    task_activity_columns(client.client_tasks.limit(1).order("client_tasks.created_at DESC"))
  end

  def task_updated
    task_activity_columns(client.client_tasks.completed.limit(1).order("client_tasks.updated_at DESC"))
  end

  def return_hash
    {
      "data": {
        total_customers: total_customers,
        since: since,
        snapshot: snapshot,
        tasks: tasks,
        overdue_invoices: overdue_invoices,
        activities: {
          invoice: invoices_sent[0],
          payment: payment_recieved[0],
          service: service[0],
          expense: expense_created[0],
          task_created: task_created[0],
          task_updated: task_updated[0]
        }
      }
    }
  end
end