class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.integer :status, default: 0
      t.datetime :sent_on
      t.references :service_ticket, foreign_key: true
      t.references :sent_by, index: true, foreign_key: { to_table: :users }
      t.references :customer, index: true, foreign_key: { to_table: :users }
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
