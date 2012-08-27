class RenameProgramAccessTokenToProgramAccessKey < ActiveRecord::Migration
  def change
    rename_column :programs, :program_access_token, :program_access_key
  end
end
