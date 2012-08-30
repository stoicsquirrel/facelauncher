class AddModeratePhotosToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :moderate_photos, :boolean
  end
end
