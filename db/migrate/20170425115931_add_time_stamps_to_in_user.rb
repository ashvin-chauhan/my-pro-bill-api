class AddTimeStampsToInUser < ActiveRecord::Migration[5.0]
  def self.up
    add_column(:users, :created_at, :datetime)
    add_column(:users, :updated_at, :datetime)
  end

  def self.down
    remove_column(:users, :created_at, :datetime)
    remove_column(:users, :updated_at, :datetime)
  end
end
