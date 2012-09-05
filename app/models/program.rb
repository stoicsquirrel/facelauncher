class Program < ActiveRecord::Base
  has_many :signups, dependent: :destroy #, inverse_of: :program
  has_many :additional_fields, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :program_photo_import_tags, dependent: :destroy

  attr_accessor :permanent_link, :edit_photos, :edit_additional_fields

  accepts_nested_attributes_for :additional_fields, allow_destroy: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :program_photo_import_tags, allow_destroy: true
  attr_accessible :additional_fields_attributes, allow_destroy: true
  attr_accessible :set_active_date, :set_inactive_date, :description,
                  :facebook_app_id, :facebook_app_secret, :facebook_is_like_gated,
                  :google_analytics_tracking_code, :name, :short_name, :app_url,
                  :repo, :moderate_signups, :moderate_photos, :permanent_link, :edit_photos,
                  :edit_additional_fields, :instagram_client_id, :instagram_client_secret,
                  :program_photo_import_tags_attributes

  validate :facebook_app_secret, :validate_fb_app_id_and_secret
  validates :name, presence: true
  validates :short_name, presence: true, length: { maximum: 100 },
                         format: { with: /^[a-zA-Z][a-zA-Z1-9\-]+$/ }
  validates :facebook_app_id, length: { maximum: 30 }
  validates :facebook_app_secret, length: { maximum: 60 }
  validates :instagram_client_id, length: { maximum: 32 }
  validates :instagram_client_secret, length: { maximum: 32 }

  def validate_fb_app_id_and_secret
    if !facebook_app_id.blank? && !facebook_app_secret.blank?
      begin
        self.facebook_app_access_token = Koala::Facebook::OAuth.new(facebook_app_id, facebook_app_secret).get_app_access_token
      rescue Koala::Facebook::APIError => e
        self.facebook_app_access_token = ''
        case e.fb_error_type
        when "OAuthException"
          # Facebook returns the following error message when the app ID looks valid
          # (correct length), but cannot be validated with the given app secret:
          # - "Cannot get application info due to a system error."
          # In this case, we will prompt the user that either the app ID or the app secret
          # may be invalid.
          #
          # If the app ID is invalid (wrong length), Facebook will return the following error:
          # - "Cannot get application info due to a system error."
          #
          # If the app secret is invalid, Facebook will return the following error:
          # - "Error validating client secret."
          #
          # As of 2012-07-26.
          #
          # TODO: Use locales file for error messages.
          # TODO: Test what happens if internet access is cut off from the server (no FB response).
          if (e.fb_error_message =~ /application ID.$/)
            errors.add(:facebook_app_id, "is invalid.")
          elsif (e.fb_error_message =~ /client secret.$/)
            errors.add(:facebook_app_secret, "is invalid.")
          elsif (e.fb_error_message =~ /system error.$/)
            errors.add(:facebook_app_id, "may be invalid.")
            errors.add(:facebook_app_secret, "may be invalid.")
          end
        end
      end
    elsif facebook_app_id.blank? and !facebook_app_secret.blank?
      self.facebook_app_access_token = ''
      errors.add(:facebook_app_id, "must be entered if a Facebook app secret has been entered.")
    elsif facebook_app_secret.blank? and !facebook_app_id.blank?
      self.facebook_app_access_token = ''
      errors.add(:facebook_app_secret, "must be entered if a Facebook app ID has been entered.")
    elsif facebook_app_id.blank? and facebook_app_secret.blank?
      self.facebook_app_access_token = ''
    end
  end

  before_create :generate_program_access_key

  def generate_program_access_key
    self.program_access_key = SecureRandom.hex
  end

  def activate
    self.active = true
    self.save
  end

  def deactivate
    self.active = false
    self.save
  end

  def facebook_app_settings_url
    !self.facebook_app_id.blank? ? "https://developers.facebook.com/apps/#{self.facebook_app_id}/" : ''
  end

  def active?
    self.active && (self.set_active_date.blank? || (!self.set_active_date.blank? && self.set_active_date < Date.now)) && (self.set_inactive_date.blank? || (!self.set_inactive_date.blank? && self.set_inactive_date > Date.now))
  end

  def get_instagram_photos_by_tags
    if !self.instagram_client_id.blank?
      # Iterate through all of the program's tags
      self.program_photo_import_tags.each do |tag|
        # Pull feed of images for this tag
        response = HTTParty.get("https://api.instagram.com/v1/tags/#{tag.tag}/media/recent?client_id=#{self.instagram_client_id}")
        # If we get an "OK" response from the server, then continue
        if response.code == 200
          # Go through each media item
          response['data'].each do |item|
            attrs = {
              photo_id: item['id'],
              caption: !item['caption'].nil? ? item['caption']['text'] : nil,
              from_user_username: !item['user'].nil? ? item['user']['username'] : nil,

              photo_album_id: 0 # Temporary
            }
            save_imported_photo(:instagram, item['images']['standard_resolution']['url'], attrs)
          end
        end
      end
    end
  end

  def get_twitter_photos_by_tags
    client = Twitter::Client.new

    # Iterate through all of the program's tags
    self.program_photo_import_tags.each do |tag|
      # Pull tweets with the current tag that have images
      begin
        client.search("##{tag.tag}", include_entities: true).results.each do |item|
          item.urls.each do |url|
            photo_id = photo_url = nil
            twitter_image_service = :twitter
            # Determine if there are photos served on an external Twitter image service
            expressions = {
              twitpic: /^https?\:\/\/twitpic.com\/(?<id>\S+)$/
            }
            expressions.each do |service, exp|
              match = exp.match(!url.expanded_url.blank? ? url.expanded_url : url.url)
              if !match.nil? && !match[:id].blank?
                photo_id = match[:id]
                photo_url = "http://twitpic.com/show/full/#{photo_id}" unless photo_id.nil?
                twitter_image_service = service
                break
              end
            end

            unless photo_id.nil?
              attrs = {
                photo_id: photo_id,
                caption: item.text,
                from_user_username: item.from_user,
                twitter_image_service: twitter_image_service,

                photo_album_id: 0
              }
              save_imported_photo(:twitter, photo_url, attrs)
            end
          end
        end
      rescue Twitter::Error::ClientError
        # TODO: Record error in the queue log.
      end
    end
  end

  private

  def save_imported_photo(service, photo_url, attrs)
    # Save the image only if it doesn't already exist in our database
    if self.photos.find_by_original_photo_id_and_from_service(attrs[:photo_id], service.to_s).nil?
      # Get the URL of this image and save it, if we get a response from the server
      response = HTTParty.get(photo_url)
      if response.code == 200
        # Get the type of image file. There may not be an extension, so let's look at the mime type.
        case response.headers['content-type']
        when "image/jpeg"
          ext = ".jpg"
        when "image/png"
          ext = ".png"
        when "image/gif"
          ext = ".gif"
        end
        # Make a temporary image file and save it if the file is good
        FileUtils.mkdir_p("#{Rails.root}/tmp/images/#{service.to_s}") # Make the temp directory if one doesn't exist

        File.open("#{Rails.root}/tmp/images/#{service.to_s}/#{attrs[:photo_id]}#{ext}", "w") do |file|
          file.binmode # File must be downloaded in binary mode

          # Save the file
          file << response.body

          # Save the photo info
          photo = self.photos.new
          photo.file.store! file
          photo[:from_service] = service.to_s
          photo[:original_photo_id] = attrs[:photo_id]
          photo[:caption] = attrs[:caption]
          photo[:from_user_username] = attrs[:from_user_username]
          photo[:photo_album_id] = attrs[:photo_album_id]
          photo[:is_approved] = false if self.moderate_photos

          photo.save
        end
      end
    end
  end
end
