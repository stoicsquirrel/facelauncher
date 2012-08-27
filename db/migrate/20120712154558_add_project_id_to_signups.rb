class AddProjectIdToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :project_id, :integer
  end
end
