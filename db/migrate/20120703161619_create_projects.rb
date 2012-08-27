class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :state
      t.string :facebook_app_id
      t.string :facebook_app_secret
      t.string :google_analytics_tracking_code
      t.string :production
      t.string :repo

      t.timestamps
    end
  end
end
