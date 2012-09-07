# RailsAdmin config file. Generated on July 16, 2012 18:25
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

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
    new do
      controller do
        Proc.new do
          if request.get? # NEW
            @object = @abstract_model.new
            @authorization_adapter && @authorization_adapter.attributes_for(:new, @abstract_model).each do |name, value|
              @object.send("#{name}=", value)
            end
            if object_params = params[@abstract_model.to_param]
              @object.set_attributes(@object.attributes.merge(object_params), _attr_accessible_role)
            end
            respond_to do |format|
              format.html { render @action.template_name }
              format.js   { render @action.template_name, :layout => false }
            end

          elsif request.post? # CREATE

            @modified_assoc = []
            @object = @abstract_model.new
            sanitize_params_for! :create

            @object.set_attributes(params[@abstract_model.param_key], _attr_accessible_role)
            @authorization_adapter && @authorization_adapter.attributes_for(:create, @abstract_model).each do |name, value|
              @object.send("#{name}=", value)
            end

            if @object.save
              @auditing_adapter && @auditing_adapter.create_object("Created #{@model_config.with(:object => @object).object_label}", @object, @abstract_model, _current_user)
              respond_to do |format|
                format.html { redirect_to_on_success }
                format.js   { render :json => { :id => @object.id, :label => @model_config.with(:object => @object).object_label } }
              end
            else
              handle_save_error
            end
          end
        end
      end
    end
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

    member :approve_item do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Photo"
      end
      controller do
        Proc.new do
          @object.generate_program_access_key

          if @object.save
            flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
            redirect_path = :back
          else
            flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
            redirect_path = back_or_index
          end

          redirect_to redirect_path
        end
      end

      http_methods [:get]
      i18n_key :regenerate_program_access_key
      link_icon 'icon-thumbs-up'
    end

    member :unapprove_item do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Photo"
      end
      controller do
        Proc.new do
          @object.generate_program_access_key

          if @object.save
            flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
            redirect_path = :back
          else
            flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
            redirect_path = back_or_index
          end

          redirect_to redirect_path
        end
      end

      http_methods [:get]
      i18n_key :regenerate_program_access_key
      link_icon 'icon-thumbs-down'
    end

    member :regenerate_program_access_key do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program"
      end
      controller do
        Proc.new do
          @object.generate_program_access_key

          if @object.save
            flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
            redirect_path = :back
          else
            flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.regenerate_program_access_key.done"))
            redirect_path = back_or_index
          end

          redirect_to redirect_path
        end
      end

      http_methods [:get]
      i18n_key :regenerate_program_access_key
      link_icon 'icon-refresh'
    end

    member :import_photos do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program"
      end
      controller do
        Proc.new do
          @object.get_instagram_photos_by_tags
          @object.get_twitter_photos_by_tags
          flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.import_photos.done"))
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

  end
  config.model AdditionalField do
    parent Program
    object_label_method :object_label

    list do
      field :program
      field :short_name
      field :label
      field :is_required
    end
    nested do
      field :short_name
      field :label
      field :is_required
    end
  end
  config.model ProgramPhotoImportTag do
    parent Program
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
    parent Program
    configure :program, :belongs_to_association
    object_label_method :object_label

    list do
      field :file, :string do
        formatted_value do
          show_photo_url = bindings[:view].rails_admin.show_url('photo', bindings[:object].id)
          image_tag = bindings[:view].cl_image_tag(bindings[:object].file.filename, crop: :fit, :width => 225, :height => 225)
          "<a href=\"#{show_photo_url}\">#{image_tag}</a>".html_safe
        end
      end
      field :is_approved
    end
    show do
      field :file, :string do
        formatted_value do
          bindings[:view].cl_image_tag(bindings[:object].file.filename, crop: :limit, width: 800, height: 800)
        end
      end
      field :is_approved
    end
    edit do
      group :file_info do
        field :program
        field :file do
          partial 'cl_form_file_upload'

          # Modified from rails_admin/lib/rails_admin/config/fields/types/carrierwave.rb
          # to use cl_image_tag instead of image_tag.
          pretty_value do
            if value.presence
              if self.image
                bindings[:view].cl_image_tag(bindings[:object].file.filename, crop: :limit, width: 800, height: 800)
              end
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
      end
      group :additional_info do
        field :title
        field :caption do
          read_only do
            !bindings[:object].from_service.blank?
          end
        end
      end
      group :social_media_info do
        field :from_service do
          read_only true
          label "Pulled from"
          help "This is automatically set if the image was pulled from a service, such as Twitter or Instagram."
        end
        field :from_twitter_image_service do
          read_only true
          label "This is automatically set if the image was pulled from an image hosting provider, via Twitter."
        end
        field :from_user_full_name do
          read_only true
          label "Full name of poster"
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
      field :photo_album_id
    end
    nested do

    end
  end
  config.model Signup do
    parent Program
    configure :program, :belongs_to_association
    configure :is_valid, :boolean
    configure :id, :integer
    configure :email, :string
    configure :first_name, :string
    configure :last_name, :string
    configure :address1, :string
    configure :address2, :string
    configure :city, :string
    configure :state, :string
    configure :zip, :string
    configure :ip_address, :string
    configure :facebook_user_id, :string
    configure :created_at, :datetime
    configure :updated_at, :datetime

    list do; end
    export do; end
    show do; end
    edit do
      group :basic_info do
        field :program
        field :email
        field :first_name
        field :last_name
        field :address1
        field :address2
        field :city
        field :state do
          help "Optional."
          render do
            # Default to US for now. Also, place this function in a helper.
            us_states = Carmen::Country.coded('US')
            bindings[:form].select('state', us_states.subregions.map { |s| [s.name, s.code] })
          end
        end
        field :zip
        field :is_valid do
          read_only true
        end
      end
      group :additional_info do
        field :facebook_user_id do
          label "Facebook user ID"
        end
        field :ip_address do
          read_only true
        end
        field :created_at do
          visible true
        end
        field :updated_at do
          visible true
        end
      end
    end
    create do
    end
    update do
      field :program do
        read_only true
      end
    end
  end
end
