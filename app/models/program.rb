class Program < ActiveRecord::Base
  has_many :signups, dependent: :destroy #, inverse_of: :program
  has_many :additional_fields, dependent: :destroy

  attr_accessor :permanent_link, :edit_photos, :edit_additional_fields

  accepts_nested_attributes_for :additional_fields, allow_destroy: true
  attr_accessible :additional_fields_attributes, allow_destroy: true
  attr_accessible :set_active_date, :set_inactive_date, :description,
                  :facebook_app_id, :facebook_app_secret, :facebook_is_like_gated,
                  :google_analytics_tracking_code, :name, :short_name, :app_url,
                  :repo, :set_signups_to_valid, :permanent_link, :edit_photos,
                  :edit_additional_fields

  validate :facebook_app_secret, :validate_fb_app_id_and_secret
  validates :name, presence: true
  validates :short_name, presence: true, length: { maximum: 100 },
                         format: { with: /^[a-zA-Z][a-zA-Z1-9\-]+$/ }
  validates :facebook_app_id, length: { maximum: 30 }
  validates :facebook_app_secret, length: { maximum: 60 }

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

  def deploy
    puts "Deploying..."
    sleep 10 # simulate deployment
    puts "Successfully deployed \"#{self.name}\""
  end

  def activate
    self.active = true
    self.save!
  end

  def deactivate
    self.active = false
    self.save!
  end

  def facebook_app_settings_url
    !self.facebook_app_id.blank? ? "https://developers.facebook.com/apps/#{self.facebook_app_id}/" : ''
  end

  def active?
    self.active && (self.set_active_date.blank? || (!self.set_active_date.blank? && self.set_active_date < Date.now)) && (self.set_inactive_date.blank? || (!self.set_inactive_date.blank? && self.set_inactive_date > Date.now))
  end
end
