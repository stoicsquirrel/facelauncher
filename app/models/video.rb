class Video < ActiveRecord::Base
  belongs_to :video_playlist
  belongs_to :program
  has_many :video_tags

  scope :approved, where(is_approved: true)

  mount_uploader :screenshot, PhotoUploader
  attr_accessible :program_id, :caption, :embed_code, :is_approved, :position,
                  :screenshot, :screenshot_cache, :remove_screenshot, :video_playlist_id

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
