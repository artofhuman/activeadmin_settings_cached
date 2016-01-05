module ActiveadminSettingsCached

  module Options
    VALID_OPTIONS = [
        :model_name,
        :scope,
        :template,
        :template_object,
        :display,
        :priority,
        :title
    ].freeze

    def self.options_for(options= {})
      options[:template_object] = ActiveadminSettingsCached::Model.new(options) unless options.has_key? :template_object

      {
        template: 'admin/settings/index',
        priority: 99,
        title: I18n.t('settings.menu.label')
      }.deep_merge(options)
    end

  end
end
