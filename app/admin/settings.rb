ActiveAdmin.register_page "Settings" do
  title = proc { I18n.t('settings.menu.label') }

  menu label: title, priority: 99

  content title: title  do
    render partial: 'admin/settings/index'
  end

  controller do
    helper :settings
  end
end
