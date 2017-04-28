class TimeTrackersController < ApplicationController
  before_action :get_client, :get_worker

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

  private

  def get_worker
    @worker = @client.workers.find(params[:worker_id])
  end
end
