module SettingsHelper
  def settings_field_type(settings_name)
    ActiveadminSettingsCached.config.display[settings_name]
  end
end
