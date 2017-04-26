class ClientExpenses::AttchmentAttributesSerializer < ActiveModel::Serializer
  attributes :id, :expense_file
  attribute :expense_file_file_name, key: "expense_file_name"

  def expense_file
    object.expense_file.url
  end
end
