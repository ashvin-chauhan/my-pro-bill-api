class TimeTrackersController < ApplicationController
  before_action :get_client

  # GET /clients/:user_id/time_trackers
  def index
    time_trackers = @client.time_trackers.includes(:worker, :time_logs)

    render json: array_serializer.new(time_trackers, serializer: TimeTrackers::TimeTrackerAttributesSerializer, worker: true), status: 200
  end

  # GET /clients/:user_id/time_trackers/search
  def search
    time_trackers = @client.time_trackers.filter(class_search_params).includes(:worker, :time_logs)

    render json: array_serializer.new(time_trackers, serializer: TimeTrackers::TimeTrackerAttributesSerializer, worker: true), status: 200
  end

  def class_search_params
    params.slice(:date, :worker_id)
  end
end
