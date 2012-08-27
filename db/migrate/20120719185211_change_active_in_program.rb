class ChangeActiveInProgram < ActiveRecord::Migration
  def change
    change_column :programs, :active, :boolean, :null => false, :default => true
  end
end
