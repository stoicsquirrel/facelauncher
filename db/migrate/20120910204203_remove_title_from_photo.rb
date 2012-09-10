class RemoveTitleFromPhoto < ActiveRecord::Migration
  def up
    remove_column :photos, :title
  end

  def down
    add_column :photos, :title, :string
  end
end
