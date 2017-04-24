class ChangeClientExpensesDataType < ActiveRecord::Migration[5.0]
  def self.up
    change_column :client_expenses, :amount, :decimal, :precision => 8, :scale => 2
    change_column :client_expenses, :start_mileage, :decimal, :precision => 8, :scale => 2
    change_column :client_expenses, :end_mileage, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    change_column :client_expenses, :amount, :integer
    change_column :client_expenses, :start_mileage, :integer
    change_column :client_expenses, :end_mileage, :integer
  end
end
