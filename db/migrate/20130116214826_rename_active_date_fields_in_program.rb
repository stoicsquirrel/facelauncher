class RenameActiveDateFieldsInProgram < ActiveRecord::Migration
  def change
    rename_column :programs, :set_inactive_date, :date_to_deactivate
    rename_column :programs, :set_active_date, :date_to_activate
  end
end
