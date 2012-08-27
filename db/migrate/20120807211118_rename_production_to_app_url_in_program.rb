class RenameProductionToAppUrlInProgram < ActiveRecord::Migration
  def change
    rename_column :programs, :production, :app_url
  end
end
