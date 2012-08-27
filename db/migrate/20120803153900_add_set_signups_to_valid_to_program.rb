class AddSetSignupsToValidToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :set_signups_to_valid, :boolean, :null => false, :default => false
  end
end
