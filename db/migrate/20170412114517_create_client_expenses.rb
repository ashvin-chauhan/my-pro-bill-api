class CreateClientExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :client_expenses do |t|
    	t.string :expense_name
    	t.integer :amount
    	t.string :vendor_name
    	t.date :expense_date
    	t.text :description
    	t.integer :start_mileage
    	t.integer :end_mileage
    	t.integer :client_id, index: true
    	t.references :expense_category, index: true
    	t.datetime :deleted_at
      t.index :deleted_at
      
      t.timestamps
    end
  end
end
