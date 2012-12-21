class DropHstore < ActiveRecord::Migration
  def up
    execute "DROP EXTENSION IF EXISTS hstore"
  end

  def down
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
  end
end
