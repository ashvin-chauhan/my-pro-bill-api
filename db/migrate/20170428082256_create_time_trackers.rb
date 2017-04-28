class CreateTimeTrackers < ActiveRecord::Migration[5.0]
  def change
    create_table :time_trackers do |t|
      t.datetime :date
      t.references :worker, index: true, foreign_key: { to_table: :users }
      t.references :client, index: true, foreign_key: { to_table: :users }
      t.float :total_time
      t.integer :current_status
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
