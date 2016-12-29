module ActiveadminSettingsCached
  module DSL
    # Declares settings function.
    #
    # @api public
    #
    # @param [Hash] options
    # @option options [String] :model_name, settings model name override (default: uses name from global config.)
    # @option options [String] :starting_with, each key must starting with, (default: nil)
    # @option options [String] :key, root key can be replacement for starting_with, (default: nil)
    # @option options [String] :tempalte custom, template rendering (default: 'admin/settings/index')
    # @option options [String] :template_object, object to use in templates (default: ActiveadminSettingsCached::Model instance)
    # @option options [String] :display, display settings override (default: nil)
    # @option options [String] :title, title value override (default: I18n.t('settings.menu.label'))
    def active_admin_settings_page(options = {}, &block)
      options.assert_valid_keys(*ActiveadminSettingsCached::Options::VALID_OPTIONS)

      options = ActiveadminSettingsCached::Options.options_for(options)
      coercion =
          ActiveadminSettingsCached::Coercions.new(options[:template_object].defaults, options[:template_object].display)

      content title: options[:title] do
        render partial: options[:template], locals: { settings_model: options[:template_object] }
      end

      page_action :update, method: :post do
        settings_params = params.require(:settings).permit!

        coercion.cast_params(settings_params) do |name, value|
          options[:template_object].save(name, value)
        end

        flash[:success] = t('activeadmin_settings_cached.settings.update.success'.freeze)
        Rails.version.to_i >= 5 ? redirect_back(fallback_location: admin_root_path) : redirect_to(:back)
      end

      instance_eval(&block) if block_given?
    end
  end
end
