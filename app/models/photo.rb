class Photo < ActiveRecord::Base
  belongs_to :photo_album, inverse_of: :photos
  belongs_to :program
  has_many :photo_tags

  scope :approved, where(is_approved: true)

  mount_uploader :file, PhotoUploader
  attr_accessible :caption, :comment_count, :file, :from_service, :from_user_full_name,
                  :from_user_id, :from_user_username, :like_count, :original_file_id,
                  :title, :file_cache, :remove_file, :photo_album_id,
                  :position, :is_approved

  validates :photo_album, presence: true
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

  private
  def object_label
    if !self.caption.blank? && !self.from_user_username.blank?
      "#{self.from_user_username.titleize} - #{self.caption.truncate(25).titleize}"
    else
      self.id
    end
  end
end
