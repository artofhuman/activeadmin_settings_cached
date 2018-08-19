# frozen_string_literal: true

require 'activeadmin_settings_cached/engine'

module ActiveadminSettingsCached
  class Configuration
    attr_accessor :model_name, :display, :fallback_location

    def model_name
      (@model_name ||= 'Setting').constantize
    end

    def display
      (@display ||= {}).with_indifferent_access
    end
    
    def fallback_location
      (@fallback_location ||= '/').constantize
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
