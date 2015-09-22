module ActiveadminSettingsCached
  class SettingsController < ApplicationController
    def update
      settings_params.each_pair do |name, value|
        settings_model[name] = value
      end

      flash[:success] = t('.success'.freeze)
      redirect_to :back
    end

    private

    def settings_params
      params.require(:settings).permit(settings_model.defaults.keys)
    end

    def settings_model
      ActiveadminSettingsCached.config.model_name
    end
  end
end
