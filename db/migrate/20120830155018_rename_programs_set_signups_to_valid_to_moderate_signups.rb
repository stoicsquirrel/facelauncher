class RenameProgramsSetSignupsToValidToModerateSignups < ActiveRecord::Migration
  def change
    rename_column :programs, :set_signups_to_valid, :moderate_signups
  end
end
