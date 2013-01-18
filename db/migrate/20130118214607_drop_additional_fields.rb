class DropAdditionalFields < ActiveRecord::Migration
  def change
    drop_table :additional_fields
    drop_table :signups
  end
end
