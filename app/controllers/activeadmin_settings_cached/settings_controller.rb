module ActiveadminSettingsCached
  class SettingsController < ApplicationController
    def update
      settings = ActiveadminSettingsCached.settings_klass

      #TODO: this method call save every param
      # save only changed values
      settings_params.each_pair do |name, value|
        settings[name] = value
      end

      redirect_to :back
    end

    private

    def settings_params
      settings_keys = ActiveadminSettingsCached.settings_klass.defaults.keys

      params.require(:settings).permit(settings_keys)
    end
  end
end
