RailsAdmin.config do |config|
  config.model Program do
    configure :signups, :has_many_association
    configure :id, :integer
    configure :short_name, :string
    configure :name, :string
    configure :description, :string
    configure :facebook_app_id, :string
    configure :facebook_app_secret, :string
    configure :facebook_app_access_token, :string
    configure :facebook_is_like_gated, :boolean
    configure :google_analytics_tracking_code, :string
    configure :app_url, :string
    configure :repo, :string
    configure :active, :boolean
    configure :moderate_signups, :boolean
    configure :moderate_photos, :boolean
    configure :set_active_date, :datetime
    configure :set_inactive_date, :datetime
    configure :created_at, :datetime
    configure :updated_at, :datetime
    configure :facebook_app_settings_url, :string
    configure :program_access_key, :string

    list do
      field :short_name
      field :name
      field :set_active_date
      field :set_inactive_date
      field :active
    end
    export do; end
    show do

    end
    create do
      field :permanent_link do
        visible false
      end
    end
    edit do
      group :management do
        field :permanent_link do
          read_only true
          formatted_value do
            url = bindings[:view].rails_admin.edit_url('program', bindings[:object].id)
            "<a href=\"#{url}\">#{url}</a>".html_safe
          end
          help "Bookmark this link for direct access to the program."
          visible do
            !bindings[:object].id.nil?
          end
        end
        field :edit_additional_fields do
          read_only true
          label "Additional fields"
          formatted_value do
            url = bindings[:view].rails_admin.index_url('additional_field')
            "<a href=\"#{url}\">View additional fields</a>".html_safe
          end
        end
      end
      group :basic_info do
        field :short_name do
          help "Required. Length up to 100. Must start with a letter and consist of only letters, numbers, and dashes."
        end
        field :name
        field :description
        field :app_url do
          label "App URL"
          help "Optional. Length up to 255. This is the URL to the client app, and is required when the program is active."
        end
        field :moderate_signups do
          help "Required. Determines whether signups to this program must be approved."
        end
        field :moderate_photos do
          help "Required. Determines whether photos program must be approved."
        end
        field :active do
          read_only true
          help do
            if bindings[:object].active?
              'Click "Deactivate" on the top of the page to deactivate this program.'
            else
              'Click "Activate" on the top of the page to activate this program.'
            end
          end
        end
        field :program_photo_import_tags
      end
      group :developer_info do
        active false
        field :program_access_key do
          read_only true
          label "Program access key"
          help "Required. This is needed by an app running an instance of Facelauncher to access the database for this program."
        end
        field :repo do
          label "Git repository URL"
          help "Optional. Length up to 255. Use an SSH URL, such as git@github.com:bigfuel/facelauncher.git"
        end
        # field :additional_fields
      end
      group :facebook_info do
        active false
        help "The app ID and app secret can be found on the Facebook app's settings page."
        field :facebook_app_id do
          label "App ID"
        end
        field :facebook_app_secret do
          label "App secret"
        end
        field :facebook_app_access_token do
          read_only true
          label "App access token"
          help "The access token will be pulled from Facebook whenever the app ID or secret have been changed."
        end
        field :facebook_app_settings_url do
          label "App settings URL"
          help 'You must be logged in to Facebook as an admin of this app in order to see this page.'
          formatted_value do
            "<a href=\"#{bindings[:object].facebook_app_settings_url}\" target=\"blank\">#{bindings[:object].facebook_app_settings_url}</a> <i class=\"icon-external-link\"></i>".html_safe unless bindings[:object].facebook_app_settings_url.blank?
          end
        end
        field :facebook_is_like_gated do
          label "Like gated"
          help "Required. Determines whether this program uses like-gate functionality."
        end
      end
      group :instagram_info do
        active false
        field :instagram_client_id do
          label "Client ID"
        end
        field :instagram_client_secret do
          label "Client secret"
        end
      end
      group :twitter_info do
        active false
        field :twitter_consumer_key do
          label "Consumer key"
        end
        field :twitter_consumer_secret do
          label "Consumer secret"
        end
        field :tumblr_consumer_key do
          label "Tumblr consumer key"
          help "Optional. This is needed only if you need to pull Tumblr images from Tweets."
        end
      end
      group :additional_info do
        active false
        field :google_analytics_tracking_code do
          label "GA tracking code"
          help "Optional. Length up to 255. For Google Analytics."
        end
        field :set_active_date
        field :set_inactive_date
        field :created_at do
          visible true
        end
        field :updated_at do
          visible true
        end
        field :signups
      end
    end
    create do; end
    update do; end
  end
end