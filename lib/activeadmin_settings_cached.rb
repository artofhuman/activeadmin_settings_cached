require 'activeadmin_settings_cached/engine'
require 'active_admin'
require 'activeadmin_settings_cached/version'
require 'activeadmin_settings_cached/engine'
require 'activeadmin_settings_cached/options'
require 'activeadmin_settings_cached/dsl'
require 'activeadmin_settings_cached/model'
::ActiveAdmin::DSL.send(:include, ActiveadminSettingsCached::DSL)

module ActiveadminSettingsCached
  class Configuration
    attr_accessor :model_name, :display

    def model_name
      (@model_name ||= 'Settings').constantize
    end

    def display
      (@display ||= {}).with_indifferent_access
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end
end
