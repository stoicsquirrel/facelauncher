class ChangeActive2InProgram < ActiveRecord::Migration
  def change
    change_column :programs, :active, :boolean, :null => false, :default => false
  end
end
