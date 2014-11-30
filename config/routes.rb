ActiveadminSettingsCached::Engine.routes.draw do
  resource :settings, only: :update
end
