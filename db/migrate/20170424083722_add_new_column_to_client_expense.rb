class AddNewColumnToClientExpense < ActiveRecord::Migration[5.0]
  def self.up
    add_reference :client_expenses, :created_by, index: true, foreign_key: { to_table: :users }
    add_column :client_expenses, :status, :integer, default: 0
  end

  def self.down
    remove_reference :client_expenses, :created_by
    remove_column :client_expenses, :status
  end
end
