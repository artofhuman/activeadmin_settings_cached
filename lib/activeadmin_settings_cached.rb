require 'activeadmin_settings_cached/engine'
require 'dry/configurable'

module ActiveadminSettingsCached
  extend Dry::Configurable

  setting :model_name, 'Setting' do |value|
    (value).constantize 
  end

  setting :display, {} do |value|
    (value).with_indifferent_access
  end
end
