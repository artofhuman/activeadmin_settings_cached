module SettingsHelper
  def settings_field_options(settings_name)
    default_value = ActiveadminSettingsCached.defaults[settings_name]
    value = ActiveadminSettingsCached.settings[settings_name]

    input_opts = if default_value.is_a?(Array)
                  {
                    collection: default_value,
                    selected: value,
                  }
                else
                  {
                    input_html: {value: value, placeholder: default_value},
                  }
                end

    {as: ActiveadminSettingsCached.config.display[settings_name], label: false}
      .merge!(input_opts)
  end
end
