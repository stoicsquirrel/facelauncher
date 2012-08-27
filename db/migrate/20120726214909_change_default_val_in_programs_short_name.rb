class ChangeDefaultValInProgramsShortName < ActiveRecord::Migration
  def change
    change_column :programs, :short_name, :string, :null => false, :limit => 50
  end
end
