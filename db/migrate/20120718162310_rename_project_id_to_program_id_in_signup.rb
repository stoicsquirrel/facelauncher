class RenameProjectIdToProgramIdInSignup < ActiveRecord::Migration
  def change
    rename_column :signups, :project_id, :program_id
  end
end
