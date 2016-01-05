require 'rails-settings-cached'

module ActiveadminSettingsCached
  class Engine < Rails::Engine
    config.mount_at = '/'
  end
end
