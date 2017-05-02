class TimeTrackers::TimeTrackerAttributesSerializer < ActiveModel::Serializer
  attributes :id, :date, :total_time
  has_many :time_logs, key: "time_logs_attributes", serializer: TimeTrackers::TimeLogsAttributesSerializer
end
