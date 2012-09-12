class CreateVideoPlaylists < ActiveRecord::Migration
  def change
    create_table :video_playlists do |t|
      t.references :program
      t.string :name
      t.string :sort_videos_by, limit: 25, null: false, default: "position ASC"

      t.timestamps
    end
    add_index :video_playlists, :program_id
  end
end
