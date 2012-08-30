class RenameIsValidToIsApprovedInPhoto < ActiveRecord::Migration
  def up
    rename_column :photos, :is_valid, :is_approved
  end

  def down
    rename_column :photos, :is_approved, :is_valid
  end
end
