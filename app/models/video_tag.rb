class VideoTag < ActiveRecord::Base
  belongs_to :video

  attr_accessible :video_id, :tag
end
