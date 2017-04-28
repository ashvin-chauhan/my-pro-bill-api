class ClientTasks::TaskSerializer < ActiveModel::Serializer
  attributes :id, :task_name, :task_description, :due_date, :status, :completed_at
  belongs_to :assign_to
  belongs_to :for_customer
  belongs_to :mark_as_completed_by
  belongs_to :created_by
end
