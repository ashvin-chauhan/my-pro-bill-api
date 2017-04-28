class ClientExpenses::ClientExpenseAttributesSerializer < ActiveModel::Serializer
  attributes :id, :client_id, :expense_name, :amount, :vendor_name, :expense_date,
             :description, :start_mileage, :end_mileage, :status, :created_by
  belongs_to :expense_category, serializer: ClientExpenses::CategoryAttributesSerializer, :if => Proc.new { instance_options[:category] == true }
  has_many :client_expense_attachments, key: "client_expense_attachments", serializer: AttchmentAttributesSerializer, :if => Proc.new { instance_options[:attachment] == true }

  def created_by
    object.created_by.full_name
  end
end
