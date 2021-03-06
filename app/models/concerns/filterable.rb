module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        if key == "date_range"
          start_date = Date.strptime(value[:start_date], "%m/%d/%Y") if value[:start_date].present?
          end_date = Date.strptime(value[:end_date], "%m/%d/%Y") if value[:end_date].present?

          if start_date && end_date
            results = results.where("DATE(#{column('created_at')}) BETWEEN ? AND ?", start_date, end_date)
          elsif start_date
            results = results.where("DATE(#{column('created_at')}) >= ?", start_date)
          elsif end_date
            results = results.where("DATE(#{column('created_at')}) <= ?", end_date)
          end

        elsif column_type(key) == :string
          results = results.where("#{column(key)} LIKE ?", "%#{value}%") if value.present?
        elsif column_type(key) == :date || column_type(key) == :datetime
          results = results.where("DATE(#{column(key)}) = ?", Date.strptime(value, "%m/%d/%Y")) if value.present?
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