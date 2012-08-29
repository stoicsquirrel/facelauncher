class Photo < ActiveRecord::Base
  belongs_to :program

  mount_uploader :file, PhotoUploader
  attr_accessible :caption, :comment_count, :file, :from_service, :from_user_full_name,
                  :from_user_id, :from_user_username, :like_count, :original_file_id,
                  :title, :file_cache, :remove_file, :program_id, :photo_album_id,
                  :position

  validates :program, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :photo_album_id, presence: true

  private
  def object_label
    self.id
  end
end
