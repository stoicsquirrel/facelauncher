class CreatePhotoAlbumPhotoImportTags < ActiveRecord::Migration
  def change
    create_table :photo_album_photo_import_tags do |t|
      t.references :photo_album
      t.string :tag, limit: 50

      t.timestamps
    end
    add_index :photo_album_photo_import_tags, :photo_album_id
  end
end
