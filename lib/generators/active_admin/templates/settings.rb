ActiveAdmin.register_page '<%= class_name %>' do
  title = '<%= class_name %>'
  menu label: title
  active_admin_settings_page(title: title)
end
