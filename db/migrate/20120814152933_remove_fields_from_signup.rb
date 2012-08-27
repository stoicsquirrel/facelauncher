class RemoveFieldsFromSignup < ActiveRecord::Migration
  def up
    remove_column :signups, :fields
  end

  def down
    add_column :signups, :fields, :hstore
  end
end
