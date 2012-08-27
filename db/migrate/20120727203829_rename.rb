class Rename < ActiveRecord::Migration
  def change
    rename_column :programs, :encrypted_instance_password, :program_access_token
  end
end
