class PhotoAlbum < ActiveRecord::Base
  belongs_to :program, inverse_of: :photo_albums
  has_many :photos

  attr_accessible :photos_attributes, allow_destroy: true
  attr_accessible :program_id, :name

  validates :program, presence: true
  validates :name, presence: true

  def approved_photos
    self.photos.select([:id, :file, :caption, :from_user_username,
      :from_user_full_name, :from_user_id, :from_service, :position, :photo_album_id,
      :from_twitter_image_service]).approved
  end

  private
  def object_label
    "#{self.program.name} - #{self.name}" unless self.program.nil?
  end
end
