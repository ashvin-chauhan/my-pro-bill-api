class MoveCustomerColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :customers, :nick_name
    remove_column :customers, :address
    remove_column :customers, :country
    remove_column :customers, :state
    remove_column :customers, :city
    remove_column :customers, :zip
    remove_column :customers, :alternate_phone
    remove_column :customers, :alternate_email

    add_column :users, :nick_name, :string
    add_column :users, :address, :text
    add_column :users, :country, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :zip, :integer
    add_column :users, :alternate_phone, :string
    add_column :users, :alternate_email, :string
  end
end
