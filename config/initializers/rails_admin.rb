# RailsAdmin config file. Generated on July 16, 2012 18:25
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Facelauncher', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

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

            # Save the user's IP address
            @object.ip_address = request.ip

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
    show_in_app

    member :activate do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program" && !bindings[:object].active
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

            if @object.activate
              flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.activate.done"))
              redirect_path = index_path
            else
              flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.activate.done"))
              redirect_path = back_or_index
            end

            redirect_to redirect_path
          end
        end
      end

      http_methods [:get, :post]
      i18n_key :activate
      link_icon 'icon-off'
    end

    member :deactivate do
      visible do
        default_visible && bindings[:abstract_model].model_name == "Program" && bindings[:object].active
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

            if @object.deactivate
              flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.deactivate.done"))
              redirect_path = index_path
            else
              flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.deactivate.done"))
              redirect_path = back_or_index
            end

            redirect_to redirect_path
          end
        end
      end

      http_methods [:get, :post]
      i18n_key :deactivate
      link_icon 'icon-off'
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

  config.model Program do
    configure :signups, :has_many_association
    configure :id, :integer
    configure :name, :string
    configure :short_name, :string
    configure :description, :string
    configure :facebook_app_id, :string
    configure :facebook_app_secret, :string
    configure :facebook_app_access_token, :string
    configure :facebook_is_like_gated, :boolean
    configure :google_analytics_tracking_code, :string
    configure :production, :string
    configure :repo, :string
    configure :active, :boolean
    configure :set_active_date, :datetime
    configure :set_inactive_date, :datetime
    configure :created_at, :datetime
    configure :updated_at, :datetime
    configure :facebook_app_developer_link, :string
    configure :encrypted_instance_password, :string

    group :basic_info do
      field :name
      field :short_name do
        help "Required. Must start with a letter and consist of only letters, numbers, and dashes."
      end
      field :description
      field :repo do
        label "Git repository URL"
        help "Optional. Use an SSH URL, such as git@github.com:bigfuel/facelauncher.git"
      end
      field :program_access_token do
        read_only true
        label "Program access token"
        help "Required. This is needed by an app running an instance of Facelauncher to access the database for this program."
      end
      field :active do
        read_only true
      end
    end
    group :facebook_info do
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
        help "The access key will be pulled from Facebook whenever the app ID or secret have been changed."
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
      end
    end
    group :additional_info do
      field :google_analytics_tracking_code do
        label "GA tracking code"
        help "Optional. For Google Analytics."
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

    list do
      include_fields :id, :name, :created_at, :description, :active
    end
    export do; end
    show do; end
    edit do

    end
    create do; end
    update do; end
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

    configure :optin_1, :string

    group :basic_info do
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

    list do; end
    export do; end
    show do; end
    edit do
      # TODO: Signups should probably not be editable at all (except possibly in a sort of debug mode).
      #exclude_fields :ip_address, :program
    end
    create do
      group :additional_info do
        field :program
      end
    end
    update do
      group :additional_info do
        field :program do
          read_only true
        end
      end
    end
  end
end
