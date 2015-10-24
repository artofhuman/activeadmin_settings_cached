require "activeadmin_settings_cached/engine"

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

    def settings
      defaults.merge! config.model_name.public_send(meth)
    end

    def defaults
      config.model_name.defaults
    end

    private

    def meth
      if Rails.version >= '4.1.0'
        :get_all
      else
        :all
      end
    end
  end
end
