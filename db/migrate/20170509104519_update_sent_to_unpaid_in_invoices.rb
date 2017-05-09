class UpdateSentToUnpaidInInvoices < ActiveRecord::Migration[5.0]
  def self.up
    # Update sent(id: 3) to unpaid(id: 2)
    Invoice.where(status: 3).update_all(status: 2)

    # Update overdue id to 3
    Invoice.where(status: 4).update_all(status: 3)
  end

  def self.down
    # Update unpaid(id: 2) to sent(id: 3)
    Invoice.where(status: 2).update_all(status: 3)

    # Update overdue id to 4
    Invoice.where(status: 3).update_all(status: 4)
  end
end
