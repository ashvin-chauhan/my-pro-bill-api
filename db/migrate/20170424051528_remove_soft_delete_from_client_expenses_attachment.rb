class RemoveSoftDeleteFromClientExpensesAttachment < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :client_expense_attachments, :deleted_at
  end

  def self.down
    add_column :client_expense_attachments, :deleted_at, :datetime
    add_index :client_expense_attachments, :deleted_at
  end
end
