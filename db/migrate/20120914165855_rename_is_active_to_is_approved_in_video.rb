class RenameIsActiveToIsApprovedInVideo < ActiveRecord::Migration
  def change
    rename_column :videos, :is_active, :is_approved
  end
end
