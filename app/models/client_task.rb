class ClientTask < ApplicationRecord
  acts_as_paranoid
  belongs_to :client, class_name: "User"
  belongs_to :assign_to, class_name: "User"
  belongs_to :for_customer, class_name: "User"
  belongs_to :mark_as_completed_by, class_name: "User"
  belongs_to :created_by, class_name: "User"

  enum status: { pending: 0, completed: 1 }
end
