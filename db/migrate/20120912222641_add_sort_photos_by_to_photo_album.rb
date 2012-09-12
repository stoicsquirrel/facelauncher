class AddSortPhotosByToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :sort_photos_by, :string, limit: 25, null: false, default: "position ASC"
  end
end
