class CheckinCheckout
  attr_accessor :worker, :client, :time_log_id

  def initialize(worker, client = nil, params = {})
    @worker = worker
    @client = client
    @time_log_id = params[:time_tracker][:time_log_id] if params.present?
  end

  def checkin
    if today_tracker.present?
      update_checkin_timetracker
    else
      create_time_tracker
    end

    TimeTrackers::CheckinCheckoutAttributesSerializer.new(today_tracker).as_json
  end

  def checkout
    update_checkout_timetracker

    TimeTrackers::CheckinCheckoutAttributesSerializer.new(today_tracker, time_log_id: time_log_id).as_json
  end

  private

  def today_tracker
    worker.worker_time_trackers.where(
      date: Date.current
    ).select(
     "id,
      worker_id,
      date,
      current_status"
    ).last
  end

  def update_checkin_timetracker
    today_tracker.update_attributes!(
      current_status: "checkin",
      time_logs_attributes: [
        checkin: Time.now
      ]
    )
  end

  def create_time_tracker
    worker.worker_time_trackers.create!(
      client: client,
      date: Date.current,
      current_status: "checkin",
      time_logs_attributes: [
        checkin: Time.now
      ]
    )
  end

  def find_timetracker
    worker.worker_time_logs.find(time_log_id).time_tracker
  end

  def update_checkout_timetracker
    find_timetracker.update_attributes!(
      current_status: 'checkout',
      time_logs_attributes: [
        checkout: Time.now, id: time_log_id
      ]
    )
  end
end