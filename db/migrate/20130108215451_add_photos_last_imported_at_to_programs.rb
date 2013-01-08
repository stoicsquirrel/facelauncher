class AddPhotosLastImportedAtToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :photos_last_imported_at, :datetime
  end
end
