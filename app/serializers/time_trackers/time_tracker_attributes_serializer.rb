class TimeTrackers::TimeTrackerAttributesSerializer < ActiveModel::Serializer
  attributes :id, :date, :total_time
  has_many :time_logs, key: "time_logs_attributes", serializer: TimeTrackers::TimeLogsAttributesSerializer
  attribute :worker, :if => Proc.new { instance_options[:worker] == true }

  def worker
    {
      id: object.worker.id,
      email: object.worker.email,
      full_name: object.worker.full_name
    }
  end
end
