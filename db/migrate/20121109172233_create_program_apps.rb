class CreateProgramApps < ActiveRecord::Migration
  def change
    create_table :program_apps do |t|
      t.references :program, :null => false
      t.string :app_url
      t.string :name, :null => false
      t.string :description
      t.string :facebook_app_id, :limit => 30
      t.string :facebook_app_secret, :limit => 60
      t.string :facebook_app_access_token, :limit => 60
      t.string :google_analytics_tracking_code, :limit => 20

      t.timestamps
    end
    add_index :program_apps, :program_id
  end
end
