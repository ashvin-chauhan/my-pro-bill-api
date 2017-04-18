require 'fileutils'
class CommonService

  # Class Methods
  class << self
    def create_file(path, extension)
      dir = File.dirname(path)

      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end

      path << ".#{extension}"
      File.new(path, 'w')
    end

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
