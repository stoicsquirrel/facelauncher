class RenameTableProgramsAdditionalFieldsToAdditionalFields < ActiveRecord::Migration
  def change
    rename_table :programs_additional_fields, :additional_fields
  end
end
