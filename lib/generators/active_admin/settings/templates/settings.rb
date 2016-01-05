ActiveAdmin.register_page '<%= class_name %>' do
  menu label: '<%= class_name %>', priority: 99, id: 'settings'
  active_admin_settings(title: '<%= class_name %>')
end
