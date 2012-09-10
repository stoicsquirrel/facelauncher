class CreatePhotoAlbums < ActiveRecord::Migration
  def change
    create_table :photo_albums do |t|
      t.references :program
      t.string :name

      t.timestamps
    end
    add_index :photo_albums, :program_id
  end
end
