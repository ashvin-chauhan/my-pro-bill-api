module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|

        if column_type(key) == :string
          results = results.where("#{column(key)} LIKE ?", "%#{value}%") if value.present?
        else
          results = results.where("#{column(key)} = ?", value) if value.present?
        end
      end
      results
    end

    def column(key)
      "#{resource_name}.#{key}"
    end

    def resource_name
      self.table_name
    end

    def column_type(key)
      self.columns_hash[key].type
    end
  end
end