class TimeTrackers::TimeTrackerAttributesSerializer < ActiveModel::Serializer
  attributes :id, :date, :total_time
  has_many :time_logs, key: "time_logs_attributes", serializer: TimeTrackers::TimeLogsAttributesSerializer
  belongs_to :worker, serializer: TimeTrackers::WorkerAttributesSerializer, :if => Proc.new { instance_options[:worker] == true }
end
