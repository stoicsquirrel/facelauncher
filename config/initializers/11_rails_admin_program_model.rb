RailsAdmin.config do |config|
  config.model Program do
    list do
      field :short_name
      field :name
      field :date_to_activate
      field :date_to_deactivate
      field :active
    end
    export do; end
    show do
      group :basic_info do
        field :name
        field :short_name
        field :description
        field :moderate_photos
        field :active

        field :app_url do
          label "App URL"
          pretty_value do
            "<a href=\"#{value}\" target=\"_blank\">#{value}</a> <i class=\"icon-external-link\"></i>".html_safe
          end
        end

        field :permanent_link do
          label "Permanent link - Bookmark this link for direct access to the program."
          pretty_value do
            url = bindings[:view].rails_admin.show_url('program', bindings[:object].id)
            "<a href=\"#{url}\">#{url}</a>".html_safe
          end

          # This field is visible if this is not a new program.
          visible do
            !bindings[:object].id.nil?
          end
        end

        field :link_to_program_photos do
          label "Photos for this program"
          pretty_value do
            url = bindings[:view].rails_admin.index_path('photo', "f[program][0][o]" => "is", "f[program][0][v]" => bindings[:object].id)
            "<a href=\"#{url}\">Photos</a>".html_safe
          end
        end

        field :link_to_program_videos do
          label "Videos for this program"
          pretty_value do
            url = bindings[:view].rails_admin.index_path('video', "f[program][0][o]" => "is", "f[program][0][v]" => bindings[:object].id)
            "<a href=\"#{url}\">Videos</a>".html_safe
          end
        end

        field :program_photo_import_tags do
          label do
            I18n.t('activerecord.models.program_photo_import_tag.other')
          end
        end
      end

#      group :facebook_info do
#        field :facebook_app_id do
#          label "App ID"
#        end
#        field :facebook_app_secret do
#          label "App secret"
#        end
#        field :facebook_app_access_token do
#          label "App access token"
#          help "The access token will be pulled from Facebook whenever the app ID or secret have been changed."
#        end
#        field :facebook_app_settings_url do
#          label "App settings URL"
#          help 'You must be logged in to Facebook as an admin of this app in order to see this page.'
#          formatted_value do
#            "<a href=\"#{bindings[:object].facebook_app_settings_url}\" target=\"blank\">#{bindings[:object].facebook_app_settings_url}</a> <i class=\"icon-external-link\"></i>".html_safe unless bindings[:object].facebook_app_settings_url.blank?
#          end
#        end
#      end
#
#      group :instagram_info do
#        help "Instagram client ID is needed to import photos from Instagram."
#
#        field :instagram_client_id do
#          label "Client ID"
#        end
#        field :instagram_client_secret do
#          label "Client secret"
#        end
#      end
#
#      group :twitter_info do
#        help "Twitter consumer key and secret are needed to import photos in tweets. Tumblr consumer key is needed to import photos on Tumblr linked by tweets."
#
#        field :twitter_consumer_key do
#          label "Consumer key"
#        end
#        field :twitter_consumer_secret do
#          label "Consumer secret"
#        end
#        field :tumblr_consumer_key do
#          label "Tumblr consumer key"
#        end
#      end

      group :additional_info do
        field :google_analytics_tracking_code do
          label "GA tracking code"
          help "Optional. Length up to 255. For Google Analytics."
        end
        field :date_to_activate
        field :date_to_deactivate
        field :photos_updated_at
        field :videos_updated_at
        field :created_at do
          visible true
        end
        field :updated_at do
          visible true
        end
      end

      group :additional_fields do
        field :additional_info_1
        field :additional_info_2
        field :additional_info_3
      end
    end
    edit do
      group :moderator_info do
        field :permanent_link do
          read_only true
          formatted_value do
            url = bindings[:view].rails_admin.edit_url('program', bindings[:object].id)
            "<a href=\"#{url}\">#{url}</a>".html_safe
          end
          help "Bookmark this link for direct access to the program."

          # This field is visible if this is not a new program.
          visible do
            !bindings[:object].id.nil?
          end
        end
        field :photos_imported_at do
          read_only true
        end
#        field :edit_additional_fields do
#          read_only true
#          label "Additional fields"
#          formatted_value do
#            url = bindings[:view].rails_admin.index_url('additional_field')
#            "<a href=\"#{url}\">View additional fields</a>".html_safe
#          end
#        end
      end
      group :basic_info do
        field :short_name do
          help "Required. Length up to 100. Must start with a letter and consist of only letters, numbers, and dashes."
        end
        field :name
        field :description
        field :app_url do
          label "App URL"
          help "Deprecated! Optional. Length up to 255. This is the URL to the client app, and is required when the program is active. For Facebook apps, use the URL on Facebook."
        end
#        field :moderate_signups do
#          help "Required. Determines whether signups to this program must be approved."
#        end
        field :moderate_photos do
          help "Optional. Determines whether photos program must be approved."
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
        field :program_photo_import_tags do
          label do
            I18n.t('activerecord.models.program_photo_import_tag.other')
          end
        end
      end
      group :developer_info do
        active false

        field :id do
          visible true
          read_only true
          label "Program ID"
          help "The program ID must be entered into your app's settings."
        end
        field :program_access_key do
          read_only true
          label "Program access key"
          help "Required. This is needed by an app running an instance of Facelauncher to access the database for this program."
        end
        field :repo do
          label "Git repository URL"
          help "Optional. Length up to 255. Use an SSH URL, such as git@github.com:bigfuel/facelauncher.git"
        end
        field :app_caches_cleared_at do
          read_only true
        end
      end
      group :admin_info do
        active false
        field :users do
          inverse_of :programs
        end
      end
      group :facebook_info do
        active false
        help "Deprecated! The app ID and app secret can be found on the Facebook app's settings page."
        field :facebook_app_id do
          label "App ID"
          help "Deprecated! Optional. Length up to 30."
        end
        field :facebook_app_secret do
          label "App secret"
          help "Deprecated! Optional. Length up to 60."
        end
        field :facebook_app_access_token do
          read_only true
          label "App access token"
          help "Deprecated! The access token will be pulled from Facebook whenever the app ID or secret have been changed."
        end
        field :facebook_app_settings_url do
          read_only true
          label "App settings URL"
          help 'Deprecated! You must be logged in to Facebook as an admin of this app in order to see this page.'
          formatted_value do
            "<a href=\"#{bindings[:object].facebook_app_settings_url}\" target=\"blank\">#{bindings[:object].facebook_app_settings_url}</a> <i class=\"icon-external-link\"></i>".html_safe unless bindings[:object].facebook_app_settings_url.blank?
          end
        end
        field :facebook_is_like_gated do
          label "Like gated"
          help "Deprecated! Optional. Determines whether this program uses like-gate functionality."
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
        help %Q(To pull Twitter tweets and their associated photos, it is necessary to enter
                a consumer key and consumer secret from a Twitter app. Go to
                <a href="https://dev.twitter.com/" target="_blank">Twitter's developer
                site <i class=\"icon-external-link\"></i></a> to create and manage your
                Twitter apps. To pull photos associated with a tweet that are originated
                on Tumblr, a Tumblr consumer key is also needed.).html_safe

        field :twitter_consumer_key do
          label "Consumer key"
        end
        field :twitter_consumer_secret do
          label "Consumer secret"
        end
        field :tumblr_consumer_key do
          label "Tumblr consumer key"
          help "Optional. This is needed only if you need to pull Tumblr images from tweets."
        end
      end
      group :additional_info do
        active false

        field :google_analytics_tracking_code do
          label "GA tracking code"
          help "Deprecated! Optional. Length up to 255. For Google Analytics."
        end
        field :date_to_activate
        field :date_to_deactivate
        field :photos_updated_at
        field :videos_updated_at
        field :created_at do
          visible true
        end
        field :updated_at do
          visible true
        end
      end
      group :additional_fields do
        active false

        field :additional_info_1
        field :additional_info_2
        field :additional_info_3
      end
      group :apps do
        field :program_apps
      end
    end
    create do; end
    update do; end
  end

  config.model ProgramApp do
    visible false
    object_label_method :object_label

    nested do
      field :id do
        visible true
        read_only true
        label "App ID"
        help "The app ID must be entered into your app's settings."
      end
      field :app_url do
        label "App URL"
        help "Optional. Length up to 255. This is the front-facing URL, and is required when the program is active. Use the Facebook app URL for Facebook apps."
      end
      field :clear_cache_url do
        label "Clear cache URL"
        help "Optional. Length up to 255. This is the URL used by Facelauncher to immediately clear the cache in the client app from the admin tool."
      end
      field :name
      field :description
      field :facebook_app_id do
        label "Facebook app ID"
      end
      field :facebook_app_secret
      field :facebook_app_access_token do
        read_only true
        help "The access token will be pulled from Facebook whenever the app ID or secret have been changed."
      end
      field :facebook_app_settings_url do
        label "Facebook app settings URL"
        help 'You must be logged in to Facebook as an admin of this app in order to view this page.'
        formatted_value do
          "<a href=\"#{bindings[:object].facebook_app_settings_url}\" target=\"blank\">#{bindings[:object].facebook_app_settings_url}</a> <i class=\"icon-external-link\"></i>".html_safe unless bindings[:object].facebook_app_settings_url.blank?
        end
      end
      field :google_analytics_tracking_code do
        label "Google Analytics tracking code"
      end
    end
  end
end