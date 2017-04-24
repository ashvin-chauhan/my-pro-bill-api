class ClientExpenses::CategoryAttributesSerializer < ActiveModel::Serializer
  attributes :id, :expense_category_name
end
