# Rails template to build the sample app for specs

generate :settings, 'Setting'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

generate :'active_admin:install --skip-users'
generate :'formtastic:install'

# Configure Setup
inject_into_file 'config/initializers/active_admin.rb', <<-RUBY, before: "ActiveAdmin.setup do |config|"
  ActiveadminSettingsCached.configure do |config|
    config.model_name = 'Setting'
  end
RUBY

route "root :to => 'admin/dashboard#index'"

rake 'db:migrate'
rake 'db:test:prepare'
