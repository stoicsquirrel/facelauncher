class ChangeColumnPhotoAlbumIdInPhoto < ActiveRecord::Migration
  def change
    change_column :photos, :photo_album_id, :integer, null: true
  end
end
