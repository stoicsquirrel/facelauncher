class CreateProgramTagsForPhotoImports < ActiveRecord::Migration
  def change
    create_table :program_photo_import_tags do |t|
      t.references :program, :null => false
      t.string :tag, :null => false, :limit => 50

      t.timestamps
    end
    add_index :program_photo_import_tags, :program_id
  end
end
