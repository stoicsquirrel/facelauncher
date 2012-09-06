class AddTumblrConsumerKeyToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :tumblr_consumer_key, :string
  end
end
