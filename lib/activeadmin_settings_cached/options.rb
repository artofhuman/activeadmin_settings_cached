# frozen_string_literal: true

module ActiveadminSettingsCached
  module Options
    VALID_OPTIONS = [
      :model_name,
      :starting_with,
      :template,
      :template_object,
      :display,
      :key,
      :title,
      :after_save,
      :fallback_location
    ].freeze

    def self.options_for(options = {})
      unless options[:template_object]
        options[:template_object] = ::ActiveadminSettingsCached::Model.new(options)
      end

      {
        template: 'admin/settings/index',
        title: I18n.t('settings.menu.label'),
        fallback_location: admin_root_path? ? admin_root_path : '/'
      }.deep_merge(options)
    end
  end
end
