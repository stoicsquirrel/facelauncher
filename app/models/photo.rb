class Photo < ActiveRecord::Base
  belongs_to :photo_album, inverse_of: :photos
  belongs_to :program, touch: true
  has_many :photo_tags

  scope :approved, where(is_approved: true)

  accepts_nested_attributes_for :photo_tags, allow_destroy: true

  mount_uploader :file, PhotoUploader
  attr_accessor :file_url
  attr_accessible :caption, :comment_count, :file, :file_url, :from_service, :from_user_full_name,
                  :from_user_id, :from_user_username, :like_count, :original_photo_id, :title,
                  :file_cache, :remove_file, :photo_album_id, :program_id, :position,
                  :is_approved, :photo_tags_attributes, :additional_info_1, :additional_info_2,
                  :additional_info_3

#  validates :program_id, presence: true
  validates :file, presence: true, :if => "file_url.nil?"
  validates :file_url, presence: true, :if => "file.nil?"

  before_save :update_program
  before_create :download_file, :approve_unless_moderated

  def update_program
    unless self.program.nil?
      self.program.photos_updated_at = DateTime.now
      self.program.program_apps.each do |program_app|
        program_app.clear_cache
      end
    end
  end

  def download_file
    # If a file URL is passed in, then download that file, and continue below to save it.
    unless self.file_url.nil?
      Faraday.new do |conn|
        conn.adapter :net_http

        # Try to pull the image file, and save it (using a tmp file), if good.
        response = conn.get(self.file_url)
        if response.status == 200
          # Look at the mime type to make sure that this is an image file.
          if response.headers['content-type'] =~ /^image\/(jpeg|gif|png)$/
            # Make a temporary image file and save it if the file is good
            FileUtils.mkdir_p("#{Rails.root}/tmp/images/uploaded_from_app") # Make the temp directory if one doesn't exist
            # Get the file name.
            filename = File.basename(self.file_url)
            # Open a new tmp file for writing, then save and send the file.
            File.open("#{Rails.root}/tmp/images/uploaded_from_app/#{filename}", "w+") do |file|
              file.binmode # File must be opened in binary mode

              # Save the file
              file << response.body
              self.file.store! file
            end
          end
        end
      end
    end

    return true
  end

  def approve_unless_moderated
    if !self.program.nil? && self.program.moderate_photos
      self.is_approved = false
    end

    return true  # This is required because the previous line (false) will cancel DB commit.
  end

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
