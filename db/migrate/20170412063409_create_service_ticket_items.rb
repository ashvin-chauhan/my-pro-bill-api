class CreateServiceTicketItems < ActiveRecord::Migration[5.0]
  def change
    create_table :service_ticket_items do |t|
      t.text :description
      t.decimal :qty_hrs, :precision => 8, :scale => 2
      t.decimal :rate, :precision => 8, :scale => 2
      t.decimal :tax_rate, :precision => 8, :scale => 2
      t.decimal :cost, :precision => 8, :scale => 2
      t.references :service_ticket, foreign_key: true
      t.references :client_service, foreign_key: true
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
