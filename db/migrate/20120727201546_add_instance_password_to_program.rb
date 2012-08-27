class AddInstancePasswordToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :encrypted_instance_password, :string, :null => false, :default => ''
  end
end
