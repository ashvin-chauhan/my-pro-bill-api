class AddSoftDeleteInAllModels < ActiveRecord::Migration[5.0]
  def change
    tables = (ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata", "services", "oauth_access_tokens"]).map { |x| x.to_sym }

    tables.each do |table_name|
      add_column table_name, :deleted_at, :datetime
      add_index table_name, :deleted_at
    end
  end
end
