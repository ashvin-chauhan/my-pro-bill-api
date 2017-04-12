class CreateServiceTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :service_tickets do |t|
      t.datetime :service_creation_date
      t.text :note
      t.boolean :has_next_visit, null: false, default: false
      t.references :customer, index: true, foreign_key: { to_table: :users }
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
