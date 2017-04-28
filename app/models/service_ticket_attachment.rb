class ServiceTicketAttachment < ApplicationRecord
  # Associations
  belongs_to :service_ticket

  # Validations
  has_attached_file :file
  validates_attachment_content_type :file, :content_type  => ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", 'application/msword','application/pdf', /\Aimage\/.*\Z/ ], message: "Only Excel, Doc, PDF, Image files are allowed"

  # Getter methods
  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
