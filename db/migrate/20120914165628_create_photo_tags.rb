class CreatePhotoTags < ActiveRecord::Migration
  def change
    create_table :photo_tags do |t|
      t.references :photo
      t.string :tag

      t.timestamps
    end
    add_index :photo_tags, :photo_id
  end
end
