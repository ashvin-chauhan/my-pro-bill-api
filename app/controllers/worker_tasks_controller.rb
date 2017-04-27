class WorkerTasksController < ApplicationController
  before_action :get_client ,:get_worker
  before_action :get_task, only: [:update,:show]

  # GET  /clients/:user_id/workers/:id/tasks
  def index
    @tasks = ClientTask.where(assign_to: @worker, client: @client)

    json_response({
      success: true,
      data: {
        worker_tasks: array_serializer.new(@tasks.includes(:assign_to, :for_customer, :created_by, :mark_as_completed_by), serializer: ClientTasks::TaskSerializer)
      }
    }, 200)
  end

  # PUT  /clients/:user_id/workers/:worker_id/tasks/:id
  def update
    @task.update_attributes!(task_params)
    @task.update_status_fields(current_resource_owner)

    json_response({
      success: true,
      data: {
        worker_task: @task
      }
    }, 201)
  end

  # GET  /clients/:user_id/workers/:worker_id/tasks/:id
  def show
    json_response({
      success: true,
      data: {
        worker_task: ClientTasks::TaskSerializer.new(@task)
      }
    }, 200)
  end

  private

  def get_worker
    @worker = @client.workers.find(params[:worker_id])
  end

  def get_task
    @task = ClientTask.where(client: @client, assign_to: @worker).find(params[:id])
  end

  def task_params
    params.require(:worker_task).permit(:status)
  end

end
