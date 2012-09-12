class CreateVideoTags < ActiveRecord::Migration
  def change
    create_table :video_tags do |t|
      t.references :video, null: false
      t.string :tag, null: false, limit: 50

      t.timestamps
    end
    add_index :video_tags, :video_id
  end
end
