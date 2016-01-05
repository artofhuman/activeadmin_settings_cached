module ActiveadminSettingsCached
  module DSL
    # Declares settings function
    #
    # Options:
    # +model_name+:: settings model name override (default: uses name from global config.)
    # +starting_with+:: each key must starting with, (default: nil)
    # +template+:: custom template rendering (default: 'admin/settings/index')
    # +template_object+:: object to use in templates (default: ActiveadminSettingsCached::Model instance)
    # +display+:: display settings override (default: nil)
    # +title+:: title value override (default: I18n.t('settings.menu.label'))
    #
    def active_admin_settings_page(options = {}, &block)
      options.assert_valid_keys(*Options::VALID_OPTIONS)

      options = Options.options_for(options)

      content title: options[:title] do
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

        flash[:success] = t('activeadmin_settings_cached.settings.update.success'.freeze)
        redirect_to :back
      end

      instance_eval(&block) if block_given?
    end
  end
end
