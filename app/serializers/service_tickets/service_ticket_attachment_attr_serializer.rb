class ServiceTickets::ServiceTicketAttachmentAttrSerializer < ActiveModel::Serializer
  attributes :id, :file

  def file
    object.file.url
  end
end
