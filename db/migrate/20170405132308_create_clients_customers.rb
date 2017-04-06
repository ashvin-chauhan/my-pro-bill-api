class CreateClientsCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :clients_customers do |t|
      t.integer :client_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
