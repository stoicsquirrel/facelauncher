class AddTwitterFieldsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :twitter_consumer_key, :string
    add_column :programs, :twitter_consumer_secret, :string
    add_column :programs, :twitter_oauth_token, :string
    add_column :programs, :twitter_oauth_token_secret, :string
  end
end
