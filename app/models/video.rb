class Video < ActiveRecord::Base
  belongs_to :video_playlist, inverse_of: :videos
  belongs_to :program
  has_many :video_tags

  scope :approved, where(is_approved: true)

  mount_uploader :screenshot, PhotoUploader
  attr_accessible :program_id, :caption, :embed_code, :is_approved, :position,
                  :screenshot, :screenshot_cache, :remove_screenshot, :video_playlist_id

  validates :video_playlist, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def approve
    self.is_approved = true
    self.save
  end

  def unapprove
    self.is_approved = false
    self.save
  end

  def self.approve(photos)
    photos.each do |photo|
      photo.approve
    end
    return photos
  end

  def self.unapprove(photos)
    photos.each do |photo|
      photo.unapprove
    end
    return photos
  end

  def approved?
    self.is_approved
  end
end
