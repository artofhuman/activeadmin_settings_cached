require 'rails-settings-cached'

module ActiveadminSettingsCached
  class Engine < Rails::Engine
    isolate_namespace ActiveadminSettingsCached

    initializer 'activeadmin_settings_cached.admin' do
      ActiveAdmin.before_load do |app|
        app.load_paths << File.expand_path("../../../app/admin", __FILE__)
      end
    end
  end
end
