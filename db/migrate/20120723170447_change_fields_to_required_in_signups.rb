class ChangeFieldsToRequiredInSignups < ActiveRecord::Migration
  def change
    change_column :signups, :email, :string, :null => false
    change_column :signups, :program_id, :integer, :null => false
  end
end
