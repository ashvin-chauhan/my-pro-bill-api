class CreateServiceTicketAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :service_ticket_attachments do |t|
      t.references :service_ticket, foreign_key: true

      t.timestamps
    end
  end
end
