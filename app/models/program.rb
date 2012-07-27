class Program < ActiveRecord::Base
  has_many :signups, dependent: :destroy #, inverse_of: :program
  # accepts_nested_attributes_for :signups, allow_destroy: true
  # attr_accessible :signups_attributes, allow_destroy: true
  attr_accessible :active, :set_active_date, :set_inactive_date, :description,
                  :facebook_app_id, :facebook_app_secret, :facebook_is_like_gated,
                  :google_analytics_tracking_code, :name, :short_name, :production, :repo

  validate :facebook_app_secret, :valid_fb_app_secret
  validates :name, presence: true
  validates :short_name, presence: true, length: { maximum: 50 },
                         format: { with: /^[a-zA-Z][a-zA-Z1-9\-]+$/ }

  def valid_fb_app_secret
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
            errors.add(:facebook_app_secret, "may be invalid")
          end
        end
      end
    end
  end

  def deploy
    puts "Deploying..."
    sleep 10 # simulate deployment
    puts "Successfully deployed \"#{self.name}\""
  end

  def activate
    self.update_attributes(active: true)
  end

  def deactivate
    self.update_attributes(active: false)
  end

  #before_save :get_facebook_app_access_token

  def get_facebook_app_access_token
    if !facebook_app_id.blank? && !facebook_app_secret.blank? && facebook_app_secret_changed?
      begin
        self.facebook_app_access_token = Koala::Facebook::OAuth.new(facebook_app_id, facebook_app_secret).get_app_access_token
      rescue Koala::Facebook::APIError => e
        # Could not get an access token.
        self.facebook_app_access_token = ''
      end
    end
  end

  def facebook_app_settings_url
    !self.facebook_app_id.blank? && !self.facebook_app_access_token.blank? ? "https://developers.facebook.com/apps/#{self.facebook_app_id}/" : ''
  end
end
