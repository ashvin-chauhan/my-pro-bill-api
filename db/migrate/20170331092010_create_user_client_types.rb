class CreateUserClientTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_client_types do |t|
      t.references :user, foreign_key: true
      t.references :client_type, foreign_key: true

      t.timestamps
    end
  end
end