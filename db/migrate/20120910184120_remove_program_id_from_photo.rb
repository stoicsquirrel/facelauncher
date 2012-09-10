class RemoveProgramIdFromPhoto < ActiveRecord::Migration
  def up
    remove_column :photos, :program_id
  end

  def down
    add_column :photos, :program_id, :integer, null: false
  end
end
