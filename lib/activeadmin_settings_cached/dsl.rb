# frozen_string_literal: true

module ActiveadminSettingsCached
  module DSL
    # Declares settings function.
    #
    # @api public
    #
    # @param [Hash] options
    # @option options [String] :model_name, settings model name override (default: uses name from global config.)
    # @option options [Symbol, Array<Symbol>] :scope, show only fields from these rails-settings-cached scopes (default: nil)
    # @option options [String] :template custom, template rendering (default: 'admin/settings/index')
    # @option options [String] :template_object, object to use in templates (default: ActiveadminSettingsCached::Model instance)
    # @option options [String] :display, display settings override (default: nil)
    # @option options [String] :title, title value override (default: I18n.t('settings.menu.label'))
    # @option options [Proc] :after_save, callback for action after page update, (default: nil)
    def active_admin_settings_page(options = {}, &block)
      options.assert_valid_keys(*ActiveadminSettingsCached::Options::VALID_OPTIONS)

      options = ActiveadminSettingsCached::Options.options_for(options)

      content title: options[:title] do
        render partial: options[:template], locals: { settings_model: options[:template_object] }
      end

      page_action :update, method: :post do
        settings_model = options[:template_object]
        settings_params = params.require(:settings).permit(*settings_model.keys)
        errors = []

        settings_params.each do |key, value|
          next unless settings_model.changed?(key, value)

          settings_model.save(key, value)
        rescue ActiveRecord::RecordInvalid => e
          errors.concat(e.record.errors.full_messages)
        end

        if errors.any?
          flash[:error] = t('activeadmin_settings_cached.settings.update.error', details: errors.join(', '))
        else
          flash[:success] = t('activeadmin_settings_cached.settings.update.success')
        end

        options[:after_save].call if options[:after_save].respond_to?(:call)
        redirect_back(fallback_location: admin_root_path)
      end

      instance_eval(&block) if block_given?
    end
  end
end
