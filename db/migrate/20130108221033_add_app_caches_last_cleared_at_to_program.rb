class AddAppCachesLastClearedAtToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :app_caches_cleared_at, :datetime
    rename_column :programs, :photos_last_imported_at, :photos_imported_at
  end
end
