class WorkerTasksController < ApplicationController
  before_action :get_client ,:get_worker
  before_action :get_task, only: [:update,:show]

  # GET  /clients/:user_id/workers/:id/tasks
  def index
    @tasks = ClientTask.where(assign_to: @worker)
    render json: array_serializer.new(@tasks.includes(:assign_to, :for_customer, :created_by, :mark_as_completed_by), serializer: ClientTasks::TaskSerializer), status: 200
  end

  # PATCH  /clients/:user_id/workers/:worker_id/tasks/:id
  def update
    @task.update_attributes!(task_params) 
    render json: @task, status: 201
  end

  # GET  /clients/:user_id/workers/:worker_id/tasks/:id
  def show
    render json: @task, serializer: ClientTasks::TaskSerializer, status: 200 
  end

  private

  def get_worker
    @worker = @client.workers.find(params[:worker_id])
  end

  def get_task
    @task = ClientTask.where(assign_to: @worker,id: params[:id]).first
  end

  def task_params
    params.require(:client_task).permit(:status)
  end

end
