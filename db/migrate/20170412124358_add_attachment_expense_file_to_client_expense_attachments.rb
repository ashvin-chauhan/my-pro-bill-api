class AddAttachmentExpenseFileToClientExpenseAttachments < ActiveRecord::Migration
  def self.up
    change_table :client_expense_attachments do |t|
      t.attachment :expense_file
    end
  end

  def self.down
    remove_attachment :client_expense_attachments, :expense_file
  end
end
