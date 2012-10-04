class AddPhotosUpdatedAtAndVideosUpdatedAtToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :photos_updated_at, :datetime
    add_column :programs, :videos_updated_at, :datetime
  end
end
