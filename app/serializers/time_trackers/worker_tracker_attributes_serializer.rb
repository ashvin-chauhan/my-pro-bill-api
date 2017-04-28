class TimeTrackers::WorkerTrackerAttributesSerializer < ActiveModel::Serializer
  attributes :id, :worker_id, :date, :current_status, :time_log

  def time_log
    if instance_options[:time_log_id]
      time_log = object.time_logs.find(instance_options[:time_log_id])
    else
      time_log = object.time_logs.last
    end

    {
      id: time_log.id,
      check_in: time_log.checkin,
      checkout: time_log.checkout
    }
  end
end
