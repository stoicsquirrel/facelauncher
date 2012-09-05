class RenameOriginalFileIdToInstagramPhotoId < ActiveRecord::Migration
  def change
    rename_column :photos, :original_file_id, :original_photo_id
  end
end
