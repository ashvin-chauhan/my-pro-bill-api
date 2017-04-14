class AddDueDateInServiceTicket < ActiveRecord::Migration[5.0]
  def self.up
    add_column :service_tickets, :due_date, :datetime
  end

  def self.down
    remove_column :service_tickets, :due_date
  end
end
