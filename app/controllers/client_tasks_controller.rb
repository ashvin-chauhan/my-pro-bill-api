class ClientTasksController < ApplicationController
  include InheritAction
  before_action :get_client
  before_action :get_task, only: [:show, :destroy, :mark_as_complete]

  # GET /clients/:user_id/tasks
  def index
    render json: array_serializer.new(@client.client_tasks.includes(:assign_to, :for_customer, :created_by, :mark_as_completed_by), serializer: ClientTasks::TaskSerializer), status: 200
  end

  # POST /clients/:user_id/tasks
  def create
    @resource = @client.client_tasks.new(resource_params)
    @resource.created_by_id = current_resource_owner.id
    super
  end

  # GET /clients/:user_id/tasks/:id
  def show
    render json: @task, serializer: ClientTasks::TaskSerializer, status: 200
  end

  # PUT /clients/:user_id/tasks/:id/mark_as_complete
  def mark_as_complete
    @task.update_attributes(completed_at: Time.current, mark_as_completed_by: current_resource_owner, status: :completed)

    render json: @task, serializer: ClientTasks::TaskSerializer, status: 201
  end

  # GET /clients/:user_id/workers/tasks
  def worker_tasks
    @task = ClientTask.where(assign_to: @client.workers.ids)
    render json: array_serializer.new(@task.includes(:assign_to, :for_customer, :created_by, :mark_as_completed_by), serializer: ClientTasks::TaskSerializer), status: 200
  end

  # GET /clients/:user_id/workers/:worker_id/tasks
  def worker_tasks_show
    @worker = @client.workers.find(params[:worker_id])
    @task = ClientTask.where(assign_to: @worker)
    render json: array_serializer.new(@task.includes(:assign_to, :for_customer, :created_by, :mark_as_completed_by), serializer: ClientTasks::TaskSerializer), status: 200
  end

  # DELETE /clients/:user_id/tasks/:id
  def destroy
    @task.destroy!

    head 200
  end

  private

  def get_task
    @task = @client.client_tasks.find(params[:id])
  end
end
