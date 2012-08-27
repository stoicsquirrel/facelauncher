class AddFieldsToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :fields, :hstore
  end
end
