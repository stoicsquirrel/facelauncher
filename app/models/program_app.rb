class ProgramApp < ActiveRecord::Base
  belongs_to :program
  attr_accessible :app_url, :description, :facebook_app_access_token, :facebook_app_id,
                  :facebook_app_secret, :google_analytics_tracking_code, :name

  validates :name, presence: true
  validates :facebook_app_id, length: { maximum: 30 }
  validates :facebook_app_secret, length: { maximum: 60 }
  validates :google_analytics_tracking_code, length: { maximum: 20 }, format: { with: /UA-\d+-\d+/ }

  def facebook_app_settings_url
    !self.facebook_app_id.blank? ? "https://developers.facebook.com/apps/#{self.facebook_app_id}/" : ''
  end
end
