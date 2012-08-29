class AddInstagramImageSizesToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :instagram_large_image_size, :string
    add_column :programs, :instagram_medium_image_size, :string
    add_column :programs, :instagram_thumbnail_image_size, :string
  end
end
