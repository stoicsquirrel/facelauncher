class ChangeColumnsToAddMoreNewLimitsInSignupts < ActiveRecord::Migration
  def change
    change_column :signups, :first_name, :string, :limit => 50
    change_column :signups, :last_name, :string, :limit => 50
    change_column :signups, :ip_address, :string, :null => false, :limit => 15
    change_column :signups, :city, :string, :limit => 40
    change_column :signups, :state, :string, :limit => 2
    change_column :signups, :zip, :string, :limit => 9

    add_column :signups, :country, :string, :limit => 2
  end
end
