class AddFromTwitterImageServiceToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :from_twitter_image_service, :string
  end
end
