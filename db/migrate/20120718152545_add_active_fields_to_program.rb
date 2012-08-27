class AddActiveFieldsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :active, :boolean
    add_column :programs, :set_active_date, :datetime
    add_column :programs, :set_inactive_date, :datetime
  end
end
