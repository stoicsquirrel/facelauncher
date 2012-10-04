class Video < ActiveRecord::Base
  belongs_to :video_playlist, inverse_of: :videos
  belongs_to :program
  has_many :video_tags

  scope :approved, where(is_approved: true)

  accepts_nested_attributes_for :video_tags, allow_destroy: true

  mount_uploader :screenshot, PhotoUploader
  attr_accessible :program_id, :caption, :embed_code, :embed_id, :is_approved, :position,
                  :screenshot, :screenshot_cache, :remove_screenshot, :video_playlist_id,
                  :video_tags_attributes

  validates :program_id, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :update_program

  def update_program
    self.program.update_attribute(:videos_updated_at, DateTime.now) unless self.program.nil?
  end

  def approve
    self.is_approved = true
    self.save
  end

  def unapprove
    self.is_approved = false
    self.save
  end

  def self.approve(videos)
    videos.each do |video|
      video.approve
    end
    return videos
  end

  def self.unapprove(videos)
    videos.each do |video|
      video.unapprove
    end
    return videos
  end

  def approved?
    self.is_approved
  end
end
