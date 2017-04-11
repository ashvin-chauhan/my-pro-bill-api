class ChangeDatatypeOfNotificationInCustomer < ActiveRecord::Migration[5.0]
  def change
    remove_column :customers, :billing_notifications
    remove_column :customers, :service_notifications

    add_column :customers, :billing_notifications, :text, array: true, default: []
    add_column :customers, :service_notifications, :text, array: true, default: []
  end
end
