class TimeTrackers::CheckinCheckoutAttributesSerializer < ActiveModel::Serializer
  attributes :id, :worker_id, :date, :current_status, :total_time, :time_log_attributes

  def time_log_attributes
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
