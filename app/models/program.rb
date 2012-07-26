class Program < ActiveRecord::Base
  has_many :signups, dependent: :destroy #, inverse_of: :program
  # accepts_nested_attributes_for :signups, allow_destroy: true
  # attr_accessible :signups_attributes, allow_destroy: true
  attr_accessible :active, :set_active_date, :set_inactive_date, :description,
                  :facebook_app_id, :facebook_app_secret, :facebook_is_like_gated,
                  :google_analytics_tracking_code, :name, :production, :repo, :state

  validate :facebook_app_secret, :valid_fb_app_secret

  def valid_fb_app_secret
    if !facebook_app_id.blank? && !facebook_app_secret.blank?
      begin
        self.facebook_app_access_token = Koala::Facebook::OAuth.new(facebook_app_id, facebook_app_secret).get_app_access_token
      rescue Koala::Facebook::APIError => e
        self.facebook_app_access_token = ''
        case e.fb_error_type
        when "OAuthException"
          if (e.fb_error_message =~ /application ID.$/)
            errors.add(:facebook_app_id, "is invalid.")
          elsif (e.fb_error_message =~ /client secret.$/)
            errors.add(:facebook_app_secret, "is invalid.")
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
