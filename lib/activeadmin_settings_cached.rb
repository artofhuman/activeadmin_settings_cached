# frozen_string_literal: true

require 'activeadmin_settings_cached/engine'

module ActiveadminSettingsCached
  class Configuration
    attr_accessor :model_name, :display, :root_path

    def model_name
      (@model_name ||= 'Setting').constantize
    end

    def root_path
      @root_path ||= :admin_root_path
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
