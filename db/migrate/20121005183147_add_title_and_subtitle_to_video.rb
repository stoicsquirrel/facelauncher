class AddTitleAndSubtitleToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :title, :string
    add_column :videos, :subtitle, :string
  end
end
