class ServiceTickets::ServiceTicketAttachmentAttrSerializer < ActiveModel::Serializer
  attributes :id, :file
  attribute :file_file_name, key: "file_name"

  def file
    object.file.url
  end
end
