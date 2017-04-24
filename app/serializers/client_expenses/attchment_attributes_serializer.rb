class ClientExpenses::AttchmentAttributesSerializer < ActiveModel::Serializer
  attributes :id, :expense_file

  def expense_file
    object.expense_file.url
  end
end
