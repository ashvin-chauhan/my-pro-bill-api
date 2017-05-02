class CreateTimeLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :time_logs do |t|
      t.time :checkin
      t.time :checkout
      t.references :time_tracker, foreign_key: true
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
