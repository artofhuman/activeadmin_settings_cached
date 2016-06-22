def add_setting_resource(options = {}, &block)
  options.merge!({model_name: 'Setting', starting_with: 'base.', title: 'Base Settings'})
  ActiveAdmin.register_page options[:title] do
    menu label: options[:title], priority: 99, parent: 'settings'
    active_admin_settings_page(options, &block)
  end
  Rails.application.reload_routes!
end

def add_second_setting_resource(options = {}, &block)
  options.merge!({model_name: 'Setting', starting_with: 'second.', title: 'Second Settings'})
  ActiveAdmin.register_page options[:title] do
    menu label: options[:title], priority: 99, parent: 'settings'
    active_admin_settings_page(options, &block)
  end
  Rails.application.reload_routes!
end

# def add_some_setting_resource(options = {}, &block)
#   options.merge!({model_name: 'Setting', title: 'Some Settings', key: 'some'})
#   ActiveAdmin.register_page options[:title] do
#     menu label: options[:title], priority: 99, parent: 'settings'
#     active_admin_settings_page(options, &block)
#   end
#   Rails.application.reload_routes!
# end

def add_all_setting_resource(options = {}, &block)
  options.merge!({model_name: 'Setting', title: 'Settings'})
  ActiveAdmin.register_page options[:title] do
    menu label: options[:title], priority: 99, id: 'settings'
    active_admin_settings_page(options, &block)
  end
  Rails.application.reload_routes!
end
