class AddFbFieldsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :facebook_is_like_gated, :boolean
  end
end
