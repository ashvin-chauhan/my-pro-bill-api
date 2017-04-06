class CreateCustomersServicePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :customers_service_prices do |t|
      t.decimal :price, :precision => 8, :scale => 2
      t.references :client_service, foreign_key: true
      t.integer :customer_id

      t.timestamps
    end
  end
end
