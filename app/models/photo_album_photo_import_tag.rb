class PhotoAlbumPhotoImportTag < ActiveRecord::Base
  belongs_to :photo_album
  attr_accessible :photo_album, :tag

  validates :tag, presence: true, length: { maximum: 50 }

  def object_label
    "##{self.tag}"
  end
end
