class AddProgramIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :program_id, :integer
  end
end
