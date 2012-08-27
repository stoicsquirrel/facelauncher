class AddValidToSignup < ActiveRecord::Migration
  def up
    remove_column :signups, :status
    add_column :signups, :is_valid, :boolean
  end

  def down
    add_column :signups, :status, :string
    remove_column :signups, :is_valid
  end
end
