class PhotoTag < ActiveRecord::Base
  belongs_to :photo
  attr_accessible :photo_id, :tag
end
