class AddAdditionalInfoFieldsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :additional_info_1, :string
    add_column :programs, :additional_info_2, :string
    add_column :programs, :additional_info_3, :string
  end
end
