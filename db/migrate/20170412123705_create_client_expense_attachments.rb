class CreateClientExpenseAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :client_expense_attachments do |t|
    	t.references :client_expense, index: true
    	t.datetime :deleted_at
      t.index :deleted_at
      
      t.timestamps
    end
  end
end
