class RemoveModerateSignupsFromProgram < ActiveRecord::Migration
  def up
    remove_column :programs, :moderate_signups
  end

  def down
    add_column :programs, :moderate_signups, :boolean
  end
end
