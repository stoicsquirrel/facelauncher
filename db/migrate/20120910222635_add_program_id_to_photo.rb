class AddProgramIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :program_id, :integer
  end
end
