class TimeTrackersController < ApplicationController
  before_action :get_client, :get_worker

  # POST /clients/:user_id/workers/:worker_id/checkin
  def checkin
    time_tracker = @worker.worker_time_trackers.create!(client: @client, date: Date.current, current_status: "checkin", time_logs_attributes: [ checkin: Time.now ])

    render json: time_tracker, include: [:time_logs], status: 201
  end

  # PUT /clients/:user_id/workers/:worker_id/checkout
  def checkout
  end

  private

  def get_worker
    @worker = @client.workers.find(params[:worker_id])
  end


end
