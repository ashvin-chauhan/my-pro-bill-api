require 'fileutils'
class CommonService

  # Class Methods
  class << self
    def create_invoice_temp_table
      Temping.create :invoice_error do
        with_columns do |t|
          t.integer :invoice_id
          t.text :error_detail
        end
      end
    end
  end
end
