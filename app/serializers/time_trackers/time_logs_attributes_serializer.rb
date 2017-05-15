class TimeTrackers::TimeLogsAttributesSerializer < ActiveModel::Serializer
  attributes :id, :checkin, :checkout
end
