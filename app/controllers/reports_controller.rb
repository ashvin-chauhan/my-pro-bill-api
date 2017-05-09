class ReportsController < ApplicationController
  before_action :get_client

  # GET /clients/:user_id/reports/summary
  def summary
    response = Report::Summary.new(@client, params).call
    render json: response, status: 200
  end
end
