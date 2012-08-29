class AddInstagramFieldsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :instagram_client_id, :string
    add_column :programs, :instagram_client_secret, :string
  end
end
