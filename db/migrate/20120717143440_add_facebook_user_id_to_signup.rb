class AddFacebookUserIdToSignup < ActiveRecord::Migration
  def change
    add_column :signups, :facebook_user_id, :string
  end
end
