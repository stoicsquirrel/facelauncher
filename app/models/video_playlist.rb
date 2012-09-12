class VideoPlaylist < ActiveRecord::Base
  belongs_to :program, inverse_of: :video_playlists
  has_many :videos

  attr_accessible :videos_attributes, allow_destroy: true
  attr_accessible :program_id, :name, :sort_videos_by

  validates :program, presence: true
  validates :name, presence: true
  validates :sort_videos_by, presence: true

  def active_videos
    self.videos.select([:id, :embed_code, :caption, :position]).active
  end
end
