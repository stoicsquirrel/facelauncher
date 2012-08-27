class ChangeSignupsIpAddress < ActiveRecord::Migration
  def up
    change_column :signups, :ip_address, :string
  end

  def down
    change_column :signups, :ip_address, :inet
  end
end
