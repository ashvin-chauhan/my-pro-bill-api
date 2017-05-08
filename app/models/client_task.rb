class ClientTask < ApplicationRecord
  include Filterable
  acts_as_paranoid

  # Associations
  belongs_to :client, class_name: "User"
  belongs_to :assign_to, class_name: "User"
  belongs_to :for_customer, class_name: "User"
  belongs_to :mark_as_completed_by, class_name: "User"
  belongs_to :created_by, class_name: "User"

  enum status: { todo: 0, completed: 1 }

  # Getter methods
  def due_date
    self[:due_date].to_s
  end

  def completed_at
    self[:completed_at].try(:strftime, "%m/%d/%Y %H:%M")
  end

  def created_at
    self[:created_at].to_s
  end

  def updated_at
    self[:updated_at].to_s
  end
end
