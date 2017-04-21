class AddAttachmentFileToServiceTicketAttachments < ActiveRecord::Migration
  def self.up
    change_table :service_ticket_attachments do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :service_ticket_attachments, :file
  end
end
