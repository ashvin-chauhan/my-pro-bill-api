class TimeTrackers::WorkerAttributesSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name
end
