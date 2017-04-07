class CreateExpenseCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :expense_categories do |t|
    	t.string :expense_category_name
    	t.integer :client_id, index: true

      t.timestamps
    end
  end
end
