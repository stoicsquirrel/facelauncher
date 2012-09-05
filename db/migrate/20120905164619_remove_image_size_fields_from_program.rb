class RemoveImageSizeFieldsFromProgram < ActiveRecord::Migration
  def up
    remove_column :programs, :instagram_large_image_size
    remove_column :programs, :instagram_medium_image_size
    remove_column :programs, :instagram_thumbnail_image_size
  end

  def down
    add_column :programs, :instagram_thumbnail_image_size, :string
    add_column :programs, :instagram_medium_image_size, :string
    add_column :programs, :instagram_large_image_size, :string
  end
end
