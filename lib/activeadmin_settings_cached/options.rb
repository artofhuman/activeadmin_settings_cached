module ActiveadminSettingsCached
  module Options
    VALID_OPTIONS = [
      :model_name,
      :starting_with,
      :template,
      :template_object,
      :display,
      :title
    ].freeze

    def self.options_for(options = {})
      options[:template_object] = ActiveadminSettingsCached::Model.new(options) unless options.key? :template_object

      {
        template: 'admin/settings/index',
        title: I18n.t('settings.menu.label')
      }.deep_merge(options)
    end
  end
end
