class AddShortNameToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :short_name, :string, :null => false, :length => 50, :default => ''
    change_column :programs, :short_name, :string, :null => false, :length => 50
    change_column :programs, :name, :string, :null => false
  end
end
