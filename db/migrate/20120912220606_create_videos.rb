class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.text :embed_code
      t.text :caption
      t.integer :position, default: 0, null: false
      t.boolean :is_active, default: true, null: false
      t.string :frame
      t.integer :video_playlist_id, null: false

      t.timestamps
    end
  end
end
