class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :program_id, null: false
      t.string :file
      t.string :title
      t.string :caption
      t.integer :like_count
      t.integer :comment_count
      t.string :from_user_username
      t.string :from_user_full_name
      t.string :from_user_id
      t.string :from_service
      t.string :original_file_id

      t.timestamps
    end
  end
end
