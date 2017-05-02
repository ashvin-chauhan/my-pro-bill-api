class WorkerTimeTrackersController < ApplicationController
  before_action :get_client, :get_worker
  before_action :get_time_tracker, only: [:show, :update]

  # POST /clients/:user_id/workers/:worker_id/checkin
  def checkin
    response = CheckinCheckout.new(@worker, @client).checkin
    render json: response, status: 201
  end

  # PUT /clients/:user_id/workers/:worker_id/checkout
  def checkout
    response = CheckinCheckout.new(@worker, nil, params).checkout
    render json: response, status: 201
  end

  # GET /clients/:user_id/workers/:worker_id/time_trackers
  def index
    time_trackers = @worker.worker_time_trackers.includes(:worker, :time_logs)

    render json: {
      worker: @worker.as_json(
        only: [
          :id,
          :email
        ],
        methods: [:full_name]
      ),
      time_trackers: array_serializer.new(time_trackers, serializer: TimeTrackers::TimeTrackerAttributesSerializer)
    }, status: 200
  end

  # GET /clients/:user_id/workers/:worker_id/time_trackers/:id
  def show
    render json: TimeTrackers::TimeTrackerAttributesSerializer.new(@time_tracker), status: 200
  end

  # PUT /clients/:user_id/workers/:worker_id/time_trackers/:id
  def update
    @time_tracker.update_attributes!(time_tracker_params)

    render json: TimeTrackers::TimeTrackerAttributesSerializer.new(@time_tracker), status: 201
  end

  private

  def get_worker
    @worker = @client.workers.find(params[:worker_id])
  end

  def get_time_tracker
    @time_tracker = @worker.worker_time_trackers.find(params[:id])
  end

  def time_tracker_params
    params.require(:time_tracker)
      .permit(
        time_logs_attributes: [
          :id, :checkin, :checkout, :_destroy
        ]
      )
  end
end
