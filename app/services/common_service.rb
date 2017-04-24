require 'fileutils'
class CommonService

  # Class Methods
  class << self
    def create_folder(name)
      dir = Rails.root.join('public', name)
      Dir.mkdir(dir) unless Dir.exist?(dir)
    end

    def create_invoice_temp_table
      Temping.teardown
      Temping.create :invoice_error do
        with_columns do |t|
          t.integer :invoice_id
          t.text :error_detail
        end
      end
    end
  end
end
