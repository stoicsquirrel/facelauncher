class Video < ActiveRecord::Base
  belongs_to :program
  belongs_to :video_playlist

  scope :active, where(is_active: true)

  mount_uploader :frame, PhotoUploader
  attr_accessible :program_id, :caption, :embed_code, :is_active, :position, :frame, :video_playlist_id

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
