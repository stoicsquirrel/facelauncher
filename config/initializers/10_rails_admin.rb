# RailsAdmin config file. Generated on July 16, 2012 18:25
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.authorize_with :cancan
  config.compact_show_view = false

  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Facelauncher', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # Note that this applies to ALL models.
  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program" && !bindings[:object].app_url.blank?
      end
      controller do
        Proc.new do
          if @abstract_model.model_name == "Program" && !@object.app_url.blank?
            redirect_to @object.app_url
          else
            redirect_to :back
          end
        end
      end
    end

    collection :bulk_approve do
      bulkable true
      visible do
        default_visible && bindings[:abstract_model].model_name == "Photo"
      end
      controller do
        Proc.new do
          if request.get? or request.post?
            @objects = list_entries(@model_config, :approve, nil, true)
            render @action.template_name
          elsif request.put?
            @objects = list_entries(@model_config, :approve, nil, true)
            processed_objects = @abstract_model.model.approve(@objects)

            approved = processed_objects.select(&:approved?)
            not_approved = processed_objects - approved

  #          processed_objects.each_with_index do |object, i|
  #            if object.approved?
  #              @auditing_adapter && @auditing_adapter.update_object(@abstract_model, object, nil, nil, nil, @objects[i], _current_user)
  #              approved_count += 1
  #            else
  #              not_approved_count += 1
  #            end
  #          end

            flash[:success] = t("admin.flash.successful", :name => pluralize(approved.count, @model_config.label), :action => t("admin.actions.bulk_approve.done")) unless approved.empty?
            flash[:error] = t("admin.flash.error", :name => pluralize(not_approved.count, @model_config.label), :action => t("admin.actions.bulk_approve.done")) unless not_approved.empty?

            redirect_to back_or_index
          end
        end
      end

      http_methods [:get, :post, :put]
      i18n_key :bulk_approve
      link_icon 'icon-thumbs-up'
    end

    collection :bulk_unapprove do
      bulkable true
      visible do
        default_visible && bindings[:abstract_model].model_name == "Photo"
      end
      controller do
        Proc.new do
          if request.get? or request.post?
            @objects = list_entries(@model_config, :unapprove, nil, true)
            render @action.template_name
          elsif request.put?
            @objects = list_entries(@model_config, :unapprove, nil, true)
            processed_objects = @abstract_model.model.unapprove(@objects)

            approved = processed_objects.select(&:approved?)
            not_approved = processed_objects - approved

            flash[:success] = t("admin.flash.successful", :name => pluralize(not_approved.count, @model_config.label), :action => t("admin.actions.bulk_unapprove.done")) unless not_approved.empty?
            flash[:error] = t("admin.flash.error", :name => pluralize(approved.count, @model_config.label), :action => t("admin.actions.bulk_unapprove.done")) unless approved.empty?

            redirect_to back_or_index
          end
        end
      end

      http_methods [:get, :post, :put]
      i18n_key :bulk_unapprove
      link_icon 'icon-thumbs-down'
    end

    member :approve do
      visible do
        model_name = bindings[:abstract_model].model_name
        default_visible && (model_name == "Photo" || model_name == "Video") && !bindings[:object].is_approved
      end
      controller do
        Proc.new do
          @object.approve

          if @object.save
            flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.approve.done"))
            redirect_path = :back
          else
            flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.approve.done"))
            redirect_path = back_or_index
          end

          redirect_to redirect_path
        end
      end

      http_methods [:get]
      i18n_key :approve
      link_icon 'icon-thumbs-up'
    end

    member :unapprove do
      visible do
        model_name = bindings[:abstract_model].model_name
        default_visible && (model_name == "Photo" || model_name == "Video") && bindings[:object].is_approved
      end
      controller do
        Proc.new do
          @object.unapprove

          if @object.save
            flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.unapprove.done"))
            redirect_path = :back
          else
            flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.unapprove.done"))
            redirect_path = back_or_index
          end

          redirect_to redirect_path
        end
      end

      http_methods [:get]
      i18n_key :unapprove
      link_icon 'icon-thumbs-down'
    end

    member :regenerate_program_access_key do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program"
      end
      controller do
        Proc.new do
          if request.get?
            respond_to do |format|
              format.html { render @action.template_name }
              format.js   { render @action.template_name, :layout => false }
            end
          elsif request.post?
            @object.generate_program_access_key

            if @object.save
              flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
              redirect_path = :back
            else
              flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
              redirect_path = back_or_index
            end

            redirect_to back_or_index
          end
        end
      end

      http_methods [:get, :post]
      i18n_key :regenerate_program_access_key
      link_icon 'icon-refresh'
    end

    member :import_photos do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program"
      end
      controller do
        Proc.new do
          Resque.enqueue(PhotoImportWorker, @object.id)
          flash[:success] = t("admin.flash.enqueued", :name => @model_config.label, :action => t("admin.actions.import_photos.enqueued"))
          redirect_to back_or_index
        end
      end

      http_methods [:get]
      i18n_key :import_photos
      link_icon 'icon-download'
    end

    member :validate do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Signup" && !bindings[:object].is_valid
      end
      controller do
        Proc.new do
          if request.get?
            respond_to do |format|
              format.html { render @action.template_name }
              format.js   { render @action.template_name, :layout => false }
            end
          elsif request.post?
            redirect_path = nil

            if @object.validate
              flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.validate.done"))
              redirect_path = index_path
            else
              flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.validate.done"))
              redirect_path = back_or_index
            end

            redirect_to redirect_path
          end
        end
      end

      http_methods [:get, :post]
      i18n_key :validate
      link_icon 'icon-thumbs-up'
    end

    member :invalidate do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Signup" && bindings[:object].is_valid
      end
      controller do
        Proc.new do
          if request.get?
            respond_to do |format|
              format.html { render @action.template_name }
              format.js   { render @action.template_name, :layout => false }
            end
          elsif request.post?
            redirect_path = nil

            if @object.invalidate
              flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.invalidate.done"))
              redirect_path = index_path
            else
              flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.invalidate.done"))
              redirect_path = back_or_index
            end

            redirect_to redirect_path
          end
        end
      end

      http_methods [:get, :post]
      i18n_key :invalidate
      link_icon 'icon-thumbs-down'
    end
  end

  def default_visible
    authorized? && (bindings[:abstract_model] ? bindings[:abstract_model].config.with(bindings).try(:visible?) : true)
  end

  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [Project, Signup]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [Project, Signup]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  config.models do
    # Configuration here will affect all included models in all scopes, handle with care!

    fields_of_type :boolean do
      formatted_value do
        "<i class=\"#{value ? 'icon-check' : 'icon-check-empty'}\"></i>".html_safe
      end
    end
  # list do
  #    # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #  end
   end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  config.model User do
    edit do
      field :email
      field :password
      field :password_confirmation
      field :role
      field :programs do
        inverse_of :users
      end
    end
  end

  config.model PhotoAlbum do
    parent Program

    export do
      field :id do
        label "ID"
      end
      field :name
      field :created_at
      field :updated_at
    end
    edit do
      field :program do
        nested_form false
      end
      field :name
      field :photos do
        associated_collection_cache_all false
        associated_collection_scope do
          video_playlist = bindings[:object]
          Proc.new do |scope|
            scope = scope.where(photo_id: photo_album.photo_id) if !photo_album.nil?
          end
        end
        help ''
      end
    end
    modal do
      field :program do
        nested_form false
      end
      field :name
      field :photos do
        visible false
      end
    end
  end
  config.model ProgramPhotoImportTag do
    visible false
    object_label_method :object_label

    edit do
      field :program
      field :tag
    end
    nested do
      field :program do
        visible false
      end
      field :tag
    end
  end
  config.model Photo do
    parent PhotoAlbum
    object_label_method :object_label

    export do
      field :id do
        label "ID"
      end
      field :file
      field :caption
      field :from_service do
        label "Social media"
        export_value do
          bindings[:object].from_service.titleize unless bindings[:object].from_service.nil?
        end
      end
      field :from_user_id do
        label "User ID"
      end
      field :from_user_username do
        label "Username"
      end
      field :from_user_full_name do
        label "User's full name"
      end
      field :is_approved do
        label "Approved"
      end
      field :created_at
      field :updated_at
      field :photo_tags do
        label "Tags"
      end
    end

    list do
      sort_by :updated_at
      sort_reverse false
      items_per_page 50

      field :id do
        label "Id"
      end
      field :caption
      field :from_user_username do
        label "Username"
        column_width 80
      end
      field :file, :string do
        column_width 125
        formatted_value do
          show_photo_url = bindings[:view].rails_admin.show_url('photo', bindings[:object].id)
          image_tag = bindings[:view].cl_image_tag(bindings[:object].file.filename, crop: :fill, :width => 125, :height => 125)
          "<a href=\"#{show_photo_url}\">#{image_tag}</a>".html_safe
        end
      end
      field :program do
        column_width 70
      end
      field :photo_album do
        label "Album"
        column_width 70
      end
      field :updated_at do
        column_width 90
        strftime_format "%Y-%m-%d %l:%M%P"
      end
      field :is_approved do
        column_width 24
        label "<i class=\"icon-check\" title=\"Approved\" alt=\"Approved\"></i>".html_safe
      end
    end
    show do
      field :file, :string do
        formatted_value do
          bindings[:view].cl_image_tag(bindings[:object].file.filename, crop: :limit, width: 800, height: 800)
        end
      end
      field :is_approved do
        label "Approved"
      end
    end
    edit do
      group :file_info do
        field :program
        field :photo_album
        field :file do
          partial 'cl_form_file_upload'

          # Modified from rails_admin/lib/rails_admin/config/fields/types/carrierwave.rb
          # to use cl_image_tag instead of image_tag.
          pretty_value do
            if value.presence
              if self.image
                filename = bindings[:object].file.filename
                image_tag = bindings[:view].cl_image_tag(filename, crop: :limit, width: 350, height: 350, title: "View full sized image", alt: '')
                "<a class=\"image_preview_link\" href=\"#{bindings[:view].cl_image_path(filename)}\" target=\"view_image\">#{image_tag}</a>".html_safe
              end
            else
              image_tag = bindings[:view].image_tag("blank.gif", title: "View full sized image", alt: '')
              "<a class=\"image_preview_link new\" href=\"#\" target=\"view_image\"><img src=\"\"></a>".html_safe
            end
          end

          read_only do
            !bindings[:object].from_service.blank?
          end
        end
        field :position
        field :is_approved do
          read_only true
        end
        field :photo_tags do
          label "Tags"
          associated_collection_cache_all false
          associated_collection_scope do
            photo_tag = bindings[:object]
            Proc.new do |scope|
              scope = scope.where(photo_id: photo_tag.photo_id) if !photo_tag.nil?
            end
          end
          help ''
        end
      end
      group :additional_info do
        field :caption do
          read_only do
            !bindings[:object].from_service.blank?
          end
        end
        field :additional_info_1
        field :additional_info_2
        field :additional_info_3
      end
      group :social_media_info do
        help "The following fields are set automatically if the photo was pulled from a social media service"
        active false

        field :from_service do
          read_only true
          label "Pulled from"
          help "The service that the photo was pulled from (Twitter, Instagram, etc.)"
        end
        field :from_twitter_image_service do
          read_only true
          label "If the photo was pulled from Twitter, then this will show which image service the photo was pulled from"
        end
        field :from_user_full_name do
          read_only true
          label "Poster's full name"
        end
        field :from_user_username do
          read_only true
          label "Poster's username"
        end
        field :from_user_id do
          read_only true
          label "Poster's user ID"
        end
      end
    end
  end
  config.model PhotoTag do
    visible false

    export do
      field :tag
    end
    nested do
      field :tag
    end
  end
  config.model VideoPlaylist do
    parent Program

    edit do
      field :program do
        nested_form false
      end
      field :name
      field :videos do
        associated_collection_cache_all false
        associated_collection_scope do
          video_playlist = bindings[:object]
          Proc.new do |scope|
            scope = scope.where(video_id: video_playlist.video_id) if !video_playlist.nil?
          end
        end
        help ''
      end
    end
    modal do
      field :program do
        nested_form false
      end
      field :name
      field :videos do
        visible false
      end
    end
  end
  config.model Video do
    parent VideoPlaylist

    list do
      sort_by :position
      sort_reverse false
      items_per_page 50

      field :screenshot, :string do
        formatted_value do
          show_video_url = bindings[:view].rails_admin.show_url('video', bindings[:object].id)
          image_tag = bindings[:view].cl_image_tag(bindings[:object].screenshot.filename, crop: :fit, :width => 200, :height => 200)
          "<a href=\"#{show_video_url}\">#{image_tag}</a>".html_safe
        end
      end
      field :program do
        column_width 70
      end
      field :video_playlist do
        label "Playlist"
        column_width 70
      end
      field :position
      field :updated_at do
        column_width 90
        strftime_format "%Y-%m-%d %l:%M%P"
      end
      field :is_approved do
        column_width 24
        label "<i class=\"icon-check\" title=\"Approved\" alt=\"Approved\"></i>".html_safe
      end
    end
    show do
      field :program
      field :video_playlist
      field :embed_code do
        label "Preview from embed code"
        formatted_value do
          bindings[:object].embed_code.html_safe
        end
      end
      field :embed_id do
        label "Embed Id"
      end
      field :title
      field :subtitle
      field :caption
      field :screenshot, :string do
        formatted_value do
          bindings[:view].cl_image_tag(bindings[:object].screenshot.filename, crop: :limit, width: 800, height: 800)
        end
      end
      field :position
      field :is_approved
    end
    edit do
      field :program
      field :video_playlist
      field :embed_code
      field :embed_id do
        label "Embed Id"
      end
      field :title
      field :subtitle
      field :caption
      field :screenshot do
        partial 'cl_form_file_upload'

        # Modified from rails_admin/lib/rails_admin/config/fields/types/carrierwave.rb
        # to use cl_image_tag instead of image_tag.
        pretty_value do
          if value.presence
            if self.image
              filename = bindings[:object].screenshot.filename
              image_tag = bindings[:view].cl_image_tag(filename, crop: :limit, width: 350, height: 350, title: "View full sized image", alt: '')
              "<a class=\"image_preview_link\" href=\"#{bindings[:view].cl_image_path(filename)}\" target=\"view_image\">#{image_tag}</a>".html_safe
            end
          else
            image_tag = bindings[:view].image_tag("blank.gif", title: "View full sized image", alt: '')
            "<a class=\"image_preview_link new\" href=\"#\" target=\"view_image\"><img src=\"\"></a>".html_safe
          end
        end
      end
      field :position do
        help "Required. Position determines the in which order the photos will appear in a photo album."
      end
      field :is_approved
      field :video_tags do
        label "Tags"
        associated_collection_cache_all false
        associated_collection_scope do
          video_tag = bindings[:object]
          Proc.new do |scope|
            scope = scope.where(photo_id: video_tag.photo_id) if !video_tag.nil?
          end
        end
        help ''
      end
    end
  end
  config.model VideoTag do
    visible false

    nested do
      field :tag
    end
  end
  config.model ProgramsAccessibleByUser do
    visible false
  end
end
