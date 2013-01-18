class Program < ActiveRecord::Base
  has_many :program_apps, dependent: :destroy, inverse_of: :program
  has_many :programs_accessible_by_users, inverse_of: :program
  has_many :users, through: :programs_accessible_by_users
  has_many :photos
  has_many :photo_albums, dependent: :destroy, inverse_of: :program
  has_many :videos
  has_many :video_playlists, dependent: :destroy, inverse_of: :program
  has_many :program_photo_import_tags, dependent: :destroy, inverse_of: :program

  scope :active_scope, lambda { where(active: true) }

  attr_accessor :permanent_link, :link_to_program_photos, :link_to_program_videos,
                :edit_photos

  accepts_nested_attributes_for :program_apps, allow_destroy: true
  # accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :program_photo_import_tags, allow_destroy: true
  #accepts_nested_attributes_for :users, allow_destroy: false
  attr_accessible :program_apps_attributes, :role, :user_ids,
                  :date_to_activate, :date_to_deactivate, :description,
                  :facebook_app_id, :facebook_app_secret, :facebook_is_like_gated,
                  :google_analytics_tracking_code, :name, :short_name, :app_url,
                  :repo, :moderate_photos, :edit_photos,
                  :instagram_client_id, :instagram_client_secret,
                  :program_photo_import_tags_attributes, :tumblr_consumer_key,
                  :twitter_consumer_key, :twitter_consumer_secret,
                  :twitter_oauth_token, :twitter_oauth_token_secret,
                  :additional_info_1, :additional_info_2, :additional_info_3

  validate :facebook_app_secret, :validate_fb_app_id_and_secret
  validates :name, presence: true
  validates :short_name, presence: true, length: { maximum: 100 },
                         format: { with: /^[a-zA-Z][a-zA-Z1-9\-]+$/ }
  validates :facebook_app_id, length: { maximum: 30 }
  validates :facebook_app_secret, length: { maximum: 60 }
  validates :instagram_client_id, length: { maximum: 32 }
  validates :instagram_client_secret, length: { maximum: 32 }

  # Deprecated in Program. TODO: Remove from this model.
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
  after_save :clear_app_caches

  # Todo: Test that all program_apps receive the clear_cache message.
  def clear_app_caches
    c = self.changed
    if (!self.app_caches_cleared_at.nil? && self.app_caches_cleared_at < 2.minutes.ago) &&
       !c.include?("app_caches_cleared_at")
      self.program_apps.each do |program_app|
        program_app.clear_cache
      end
      self.update_attribute(:app_caches_cleared_at, DateTime.now)
    end
  end

  def authenticate(key)
    self.program_access_key == key
  end

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

  def photo_tags
    self.program_photo_import_tags.select([:tag]).map {|t| t.tag }
  end

  def activate_on_date
    self.active = true if !self.date_to_activate.nil? && DateTime.now >= self.date_to_activate
    self.date_to_activate = nil
    self.save
  end

  def deactivate_on_date
    self.active = false if !self.date_to_deactivate.nil? && DateTime.now >= self.date_to_deactivate
    self.date_to_deactivate = nil
    self.save
  end

  # TODO: Remove from this model.
  def facebook_app_settings_url
    !self.facebook_app_id.blank? ? "https://developers.facebook.com/apps/#{self.facebook_app_id}/" : ''
  end

  def import_photos_by_tags
    if self.active?
      import_instagram_photos_by_tags
      import_twitter_photos_by_tags
      self.update_attribute(:photos_imported_at, DateTime.now)
      clear_app_caches
    end
  end

  def import_instagram_photos_by_tags
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
              from_user_full_name: !item['user'].nil? ? item['user']['full_name'] : nil,
              from_user_id: !item['user'].nil? ? item['user']['id'] : nil
            }
            download_and_save_photo(:instagram, item['images']['standard_resolution']['url'], attrs)
          end
        end
      end
    end
  end

  def import_twitter_photos_by_tags
    client = Twitter::Client.new

    # Iterate through all of the program's tags.
    self.program_photo_import_tags.each do |tag|
      # Pull up to 1000 tweets with the current tag that have images.
      10.times do |i|
        page = i + 1

        retry_attempts = 0
        begin
          results = client.search("##{tag.tag}", include_entities: true, rpp: 100, page: page).results
        rescue Twitter::Error::ServiceUnavailable
          # If Twitter is over capacity or unavailable, then wait five seconds and try again up to two times.
          if retry_attempts < 3
            retry_attempts += 1
            sleep 5
            retry
          else
            # If we've exhausted all retry attempts, then stop.
            raise
          end
        end

        # If there are no results on this page, then we're done
        break if results.count == 0
        # Iterate through results on this page
        results.each do |item|
          if item.media.any?
            # Determine if there are any included images (hosted by Twitter/Photobucket).
            item.media.each do |media|
              attrs = {
                photo_id: media.id,
                caption: item.text,
                from_user_username: item.from_user,
                from_user_full_name: item.from_user_name,
                from_user_id: item.from_user_id,
                twitter_image_service: :twitter
              }
              download_and_save_photo(:twitter, media.media_url, attrs)
            end
          elsif item.urls.any?
            # Determine if there are any images hosted on services such as Twitpic, YFrog, etc.
            item.urls.each do |url|
              expanded_url = !url.expanded_url.blank? ? url.expanded_url : url.url
              photo = import_photo(expanded_url)

              # If we found a photo, then save it
              unless photo.nil?
                attrs = {
                  photo_id: photo[:id],
                  caption: item.text,
                  from_user_username: item.from_user,
                  from_user_full_name: item.from_user_name,
                  from_user_id: item.from_user_id,
                  twitter_image_service: photo[:twitter_image_service]
                }
                download_and_save_photo(:twitter, photo[:url], attrs)
              end
            end
          end
        end
      end
    end
  end

  private

  # Recursive function to open URLs and search for photos.
  def import_photo(expanded_url)
    photo = Hash.new
    twitter_image_service = nil

    # Search expanded URLs for twitpic.com, yfrog.com, etc.
    expressions = {
      twitpic: /^https?\:\/\/twitpic.com\/(?<id>\S+)$/,
      tumblr: /^https?\:\/\/(tmblr.co|\S+\.tumblr.com)\/\S+$/
    }
    expression = /^https?\:\/\/(?<service>tmblr.co|\S+\.tumblr.com|twitpic.com)\/(?<id>\S+)$/
    match = expression.match(expanded_url)

    # If there is no match, check if the URL redirects to another, and if it does,
    # call this function again with the redirect URL.
    # If there is no redirect, then the method ends.
    if match.nil?
      begin
        expanded_expanded_url = HTTParty.get(expanded_url, follow_redirects: false).headers["location"]
      rescue StandardError # If there is any error, just continue to the next item.
        # If the request times out or we get a bad URL, continue to the next item.
        return nil
      end
      if !expanded_expanded_url.nil?
        return import_photo(URI::encode(expanded_expanded_url))
      end
    else
      case match[:service]
      # Pull image from Twitpic
      when 'twitpic.com'
        unless match[:id].blank?
          photo[:id] = match[:id]
          photo[:url] = "http://twitpic.com/show/full/#{photo[:id]}" unless photo[:id].nil?
          photo[:twitter_image_service] = :twitpic
          return photo
        end
      # Pull image from Tumblr
      when 'tumblr.com', 'tmblr.co'
        unless self.tumblr_consumer_key.blank?
          # If this is a tmblr.co URL, then it must be a redirect.
          if (/tmblr\.co/ =~ expanded_url) >= 0
            begin
              tumblr_page_url = URI::encode(HTTParty.get(expanded_url, follow_redirects: false).headers["location"])
            rescue StandardError
              # If the request times out, continue to the next item.
              return nil
            end
          else
            tumblr_page_url = expanded_url
          end
          begin
            expanded_tumblr_page_url = URI::encode(HTTParty.get(tumblr_page_url, follow_redirects: false).headers["location"])
            logger.info "Expanded Tumblr URL: #{expanded_tumblr_page_url}"
          rescue StandardError
            # If the request times out, continue to the next item.
            return nil
          end
          tumblr_page_info = /^https?\:\/\/(?<username>\S+)\.tumblr.com\/post\/(?<page_id>\d+)\/?\S*$/.match(expanded_tumblr_page_url)
          if !tumblr_page_info.nil?
            tumblr_page_id = tumblr_page_info[:page_id]
            tumblr_user_id = tumblr_page_info[:username]
            response = HTTParty.get("https://api.tumblr.com/v2/blog/#{tumblr_user_id}.tumblr.com/posts/photo",
              query: {api_key: self.tumblr_consumer_key, id: tumblr_page_id})

            # If we get an OK response from the server, then save the photo
            if response.code == 200
              # If there is a photo in this post, then save it
              if !response['response']['posts'][0]['photos'].nil?
                photo[:id] = tumblr_page_id
                photo[:url] = response['response']['posts'][0]['photos'][0]['original_size']['url']
                photo[:twitter_image_service] = :tumblr
                return photo
              end
            end
          end
        end
      end
    end

    return nil
  end

  def download_and_save_photo(service, photo_url, attrs)
    # Save the image only if it doesn't already exist in our database
    if !self.photos.where(original_photo_id: attrs[:photo_id].to_s, from_service: service.to_s).exists?
      # Get the URL of this image and save it, if we get a response from the server
      begin
        response = HTTParty.get(photo_url)
      rescue Timeout::Error
        # Try again once if the request times out, then quit.
        begin
          response = HTTParty.get(photo_url)
        rescue StandardError
          return nil
        end
      rescue StandardError
        return nil
      end
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
          file.binmode # File must be opened in binary mode

          # Save the file
          file << response.body

          # Save the photo info
          photo = self.photos.new
          photo.file.store! file
          photo[:from_service] = service.to_s
          photo[:from_twitter_image_service] = attrs[:twitter_image_service]
          photo[:original_photo_id] = attrs[:photo_id]
          photo[:caption] = attrs[:caption]
          photo[:from_user_username] = attrs[:from_user_username]
          photo[:from_user_full_name] = attrs[:from_user_full_name]
          photo[:from_user_id] = attrs[:from_user_id]

          photo.save
        end
      end
    end
  end
end
