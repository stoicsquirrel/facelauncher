class AddClearCacheUrlToProgramApps < ActiveRecord::Migration
  def change
    add_column :program_apps, :clear_cache_url, :string
  end
end
