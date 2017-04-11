class CreateClientTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :client_tasks do |t|
      t.references :client, index: true, foreign_key: { to_table: :users }
      t.string :task_name
      t.text :task_description
      t.references :assign_to, index: true, foreign_key: { to_table: :users }
      t.datetime :due_date
      t.references :for_customer, index: true, foreign_key: { to_table: :users }
      t.integer :status, default: 0
      t.references :mark_as_completed_by, index: true, foreign_key: { to_table: :users }
      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.datetime :completed_at
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
