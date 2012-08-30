class Photo < ActiveRecord::Base
  belongs_to :program

  mount_uploader :file, PhotoUploader
  attr_accessible :caption, :comment_count, :file, :from_service, :from_user_full_name,
                  :from_user_id, :from_user_username, :like_count, :original_file_id,
                  :title, :file_cache, :remove_file, :program_id, :photo_album_id,
                  :position, :is_approved

  validates :program, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :photo_album_id, presence: true

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
    self.id
  end
end