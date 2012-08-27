class ChangeColumnsToAddNewLimitsInSignupts < ActiveRecord::Migration
  def change
    change_column :signups, :email, :string, :null => false, :limit => 100
  end
end
