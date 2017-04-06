class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :nick_name
      t.integer :billing_period
      t.boolean :should_print_invoice, null: false, default: false
      t.boolean :has_email_invoice, null: false, default: false
      t.integer :billing_notifications
      t.integer :service_notifications
      t.text :address
      t.string :country
      t.string :state
      t.string :city
      t.integer :zip
      t.string :alternate_phone
      t.string :alternate_email
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
