module SettingsHelper
  def settings_field_options(settings_name, settings_model)
    default_value = settings_model.defaults[settings_name]
    value = settings_model.settings[settings_name]

    input_opts = if default_value.is_a?(Array)
                   {
                     collection: default_value,
                     selected: value,
                   }
                 else
                   {
                     input_html: { value: value, placeholder: default_value },
                   }
                 end

    { as: settings_model.display[settings_name], label: false }
      .merge!(input_opts)
  end
end
