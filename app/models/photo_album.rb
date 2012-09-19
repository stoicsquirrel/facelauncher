class PhotoAlbum < ActiveRecord::Base
  belongs_to :program, inverse_of: :photo_albums
  has_many :photos

  attr_accessible :photos_attributes, :program_id, :name, :sort_photos_by

  # Uncomment to allow editing of photos from the photo album edit page.
  # accepts_nested_attributes_for :photos, allow_destroy: true

  validates :program, presence: true
  validates :name, presence: true
  validates :sort_photos_by, presence: true

  def approved_photos
    case self.sort_photos_by.downcase
    when "position asc", "position desc", "id asc", "id desc"
      order = self.sort_photos_by.downcase
    else
      order = 'id ASC'
    end
    self.photos.select([:id, :file, :caption, :from_user_username,
      :from_user_full_name, :from_user_id, :from_service, :position,
      :from_twitter_image_service]).approved.order(order)
  end

  private
  def object_label
    "#{self.program.name} - #{self.name}" unless self.program.nil?
  end
end
