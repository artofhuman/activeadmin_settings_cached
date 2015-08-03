module ActiveadminSettingsCached
  class SettingsController < ApplicationController
    def update
      settings = ActiveadminSettingsCached.settings_klass

      settings_params.each_pair do |name, value|
        settings[name] = value
      end

      flash[:success] = t('.success'.freeze)
      redirect_to :back
    end

    private

    def settings_params
      settings_keys = ActiveadminSettingsCached.settings_klass.defaults.keys

      params.require(:settings).permit(settings_keys)
    end
  end
end
