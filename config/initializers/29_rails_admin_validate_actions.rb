RailsAdmin.config do |config|
  config.actions do
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
  end
end