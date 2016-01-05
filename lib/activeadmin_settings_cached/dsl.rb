module ActiveadminSettingsCached
  module DSL

    # Declares settings function
    #
    # Options:
    # +model_name+:: settings model name to constantize
    # +scope+:: scope in which we will edit settings
    # +template+:: custom template rendering
    # +template_object+:: object to use in templates, ActiveadminSettingsCached::Model instance
    # +display+:: display settings
    # +priority+:: menu priority
    # +title+:: title value (default I18n.t('settings.menu.label'))
    #
    def active_admin_settings(options = {}, &block)
      options.assert_valid_keys(*Options::VALID_OPTIONS)

      options = Options.options_for(options)

      content title: options[:title]  do
        render partial: options[:template], locals: { settings_model: options[:template_object] }
      end

      controller do
        helper :settings
      end

      page_action :update, method: :post do
        settings_params = params.require(:settings).permit(options[:template_object].defaults.keys)

        settings_params.each_pair do |name, value|
          options[:template_object][name] = value
        end

        flash[:success] = t('.success'.freeze)
        redirect_to :back
      end

      instance_eval &block if block_given?
    end
  end
end
