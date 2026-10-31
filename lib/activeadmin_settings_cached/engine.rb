# frozen_string_literal: true

require 'rails-settings-cached'
require 'active_admin'

module ActiveadminSettingsCached
  class Engine < Rails::Engine
    initializer 'activeadmin_settings_cached' do
      ::ActiveAdmin::DSL.send(:include, ::ActiveadminSettingsCached::DSL)
    end
  end
end
