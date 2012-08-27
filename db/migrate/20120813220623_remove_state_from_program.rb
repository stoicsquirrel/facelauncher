class RemoveStateFromProgram < ActiveRecord::Migration
  def up
    remove_column :programs, :state
  end

  def down
    add_column :programs, :state, :string
  end
end
