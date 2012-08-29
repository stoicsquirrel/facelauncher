class AddPositionAndPhotoAlbumIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :position, :integer, default: 0, null: false
    add_column :photos, :photo_album_id, :integer, null: false
    add_column :photos, :is_valid, :boolean, default: true, null: false
  end
end
