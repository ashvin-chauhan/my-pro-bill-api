class ClientTask < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :client, class_name: "User"
  belongs_to :assign_to, class_name: "User"
  belongs_to :for_customer, class_name: "User"
  belongs_to :mark_as_completed_by, class_name: "User"
  belongs_to :created_by, class_name: "User"

  enum status: { pending: 0, completed: 1 }

  ####
  # 1. If task status is pending then reset mark_as_completed_by and completed_at columns
  # 2. If task status is completed then set mark_as_completed_by as current login
  #    user (client_admin/worker) and completed_at as current time
  ####
  def update_status_fields(completed_by)
    if pending?
      self.update_attributes!(mark_as_completed_by: nil, completed_at: nil)
    elsif completed?
      self.update_attributes!(mark_as_completed_by: completed_by, completed_at: Time.current)
    end
  end
end
