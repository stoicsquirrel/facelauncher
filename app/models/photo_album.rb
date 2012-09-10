class PhotoAlbum < ActiveRecord::Base
  belongs_to :program, inverse_of: :photo_albums
  has_many :photos

  attr_accessible :photos_attributes, allow_destroy: true
  attr_accessible :program_id, :name

  validates :program, presence: true
  validates :name, presence: true

  private
  def object_label
    "#{self.program.name} - #{self.name}" unless self.program.nil?
  end
end
