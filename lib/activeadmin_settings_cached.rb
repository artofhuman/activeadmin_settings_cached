require "activeadmin_settings_cached/engine"

module ActiveadminSettingsCached
  mattr_accessor :settings_class
  self.settings_class = "Settings"

  class << self
    def settings_klass
      settings_class.constantize
    end
  end
end
