class VideoPlaylist < ActiveRecord::Base
  belongs_to :program, inverse_of: :video_playlists
  has_many :videos

  attr_accessible :videos_attributes, :program_id, :name, :sort_videos_by

  # Uncomment to allow editing of videos from the video playlist edit page.
  # accepts_nested_attributes_for :videos, allow_destroy: true

  validates :program, presence: true
  validates :name, presence: true
  validates :sort_videos_by, presence: true

  def approved_videos
    self.videos.select([:id, :embed_code, :caption, :position, :screenshot]).approved
  end
end
