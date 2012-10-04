class AddEmbedIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :embed_id, :string
  end
end
