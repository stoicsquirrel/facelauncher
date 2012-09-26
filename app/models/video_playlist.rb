class VideoPlaylist < ActiveRecord::Base
  belongs_to :program, inverse_of: :video_playlists
  has_many :videos

  attr_accessible :videos_attributes, :program_id, :name, :sort_videos_by

  # Uncomment to allow editing of videos from the video playlist edit page.
  accepts_nested_attributes_for :videos, allow_destroy: true

  validates :program, presence: true
  validates :name, presence: true
  validates :sort_videos_by, presence: true

  def approved_videos
    order = sort_order

    self.videos.select([:id, :embed_code, :caption, :position, :screenshot]).approved.order(order)
  end

  def sort_order
    case self.sort_videos_by.downcase
    when "position asc", "position desc", "id asc", "id desc"
      order = self.sort_videos_by.downcase
    else
      order = 'position ASC'
    end
  end
end
