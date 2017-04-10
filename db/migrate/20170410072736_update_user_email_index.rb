class UpdateUserEmailIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true, where: "deleted_at IS NOT NULL"
  end
end
