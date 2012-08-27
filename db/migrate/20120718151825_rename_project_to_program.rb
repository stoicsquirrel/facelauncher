class RenameProjectToProgram < ActiveRecord::Migration
  def change
    rename_table :projects, :programs
  end
end
