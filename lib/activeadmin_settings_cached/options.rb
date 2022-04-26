# frozen_string_literal: true

module ActiveadminSettingsCached
  module Options
    VALID_OPTIONS = [
      :model_name,
      :template,
      :template_object,
      :display,
      :title,
      :after_save
    ].freeze

    def self.options_for(options = {})
      unless options[:template_object]
        options[:template_object] = ::ActiveadminSettingsCached::Model.new(options)
      end

      {
        template: 'admin/settings/index',
        title: I18n.t('settings.menu.label')
      }.deep_merge(options)
    end
  end
end
