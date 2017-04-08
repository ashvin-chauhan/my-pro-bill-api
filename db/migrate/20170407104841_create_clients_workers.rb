class CreateClientsWorkers < ActiveRecord::Migration[5.0]
  def change
    create_table :clients_workers do |t|
      t.integer :client_id
      t.integer :worker_id

      t.timestamps
    end
  end
end
