# frozen_string_literal: true

require 'activeadmin_settings_cached/engine'
require 'activeadmin_settings_cached/dsl'

module ActiveadminSettingsCached
  class Configuration
    attr_accessor :model_name, :display

    def model_name
      (@model_name ||= 'Setting').constantize
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
