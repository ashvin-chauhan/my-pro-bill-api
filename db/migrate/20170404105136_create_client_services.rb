class CreateClientServices < ActiveRecord::Migration[5.0]
  def change
    create_table :client_services do |t|
      t.string :service_name
      t.references :user, foreign_key: true
      t.references :client_type, foreign_key: true

      t.timestamps
    end
  end
end
