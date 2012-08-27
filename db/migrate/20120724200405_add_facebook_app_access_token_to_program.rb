class AddFacebookAppAccessTokenToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :facebook_app_access_token, :string
  end
end
