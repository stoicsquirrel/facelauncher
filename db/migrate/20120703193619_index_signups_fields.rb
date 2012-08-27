class IndexSignupsFields < ActiveRecord::Migration
  def up
    execute "CREATE INDEX signups_fields ON signups USING GIN(fields)"
  end

  def down
    execute "DROP INDEX signups_fields"
  end
end
