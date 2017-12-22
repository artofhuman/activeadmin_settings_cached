# frozen_string_literal: true

def base_add_resource(options = {}, &block)
  ActiveAdmin.register_page options[:title] do
    menu label: options[:title], priority: 99, parent: 'settings'
    active_admin_settings_page(options, &block)
  end
  Rails.application.reload_routes!
end

def add_setting_resource(options = {}, &block)
  options = { model_name: 'Setting', starting_with: 'base.', title: 'Base Settings',
              after_save: -> {} }.merge!(options)
  base_add_resource(options, &block)
end

def add_second_setting_resource(options = {}, &block)
  options = { model_name: 'Setting', starting_with: 'second.',
              title: 'Second Settings' }.merge!(options)
  base_add_resource(options, &block)
end

def add_some_setting_resource(options = {}, &block)
  options = { model_name: 'Setting', title: 'Some Settings', key: 'some',
              after_save: -> {} }.merge!(options)
  base_add_resource(options, &block)
end

def add_all_setting_resource(options = {}, &block)
  options[:model_name] = 'Setting'
  options[:title] = 'Settings'
  base_add_resource(options, &block)
end
