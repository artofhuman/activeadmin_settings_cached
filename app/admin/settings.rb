ActiveAdmin.register_page "Settings" do
  title = proc { I18n.t('settings.menu.label') }

  menu label: title, priority: 99

  content title: title  do
    render partial: 'admin/settings/index'
  end

  controller do
    def settings_list
      settings = ActiveadminSettingsCached.settings_klass
      settings.defaults.merge!(settings.get_all)
    end
  end
end
