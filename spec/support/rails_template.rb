# Rails template to build the sample app for specs

generate :settings, 'Setting'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

generate :'active_admin:install --skip-users'
generate :'formtastic:install'
generate :'settings:install'

# Configure Setup
inject_into_file 'config/initializers/active_admin.rb', <<-RUBY, before: "ActiveAdmin.setup do |config|"
  ActiveadminSettingsCached.configure do |config|
    config.model_name = 'Setting'
  end
RUBY

# Default Settings
inject_into_file 'config/app.yml', <<-YAML, after: "defaults: &defaults\n"
  some:
    first_setting: AAA
    second_setting: true
  'base.first_setting': AAA
  'base.second_setting': true
  'base.third_setting': 5
  'base.four_setting': 5.50
  'base.five_setting': :aaa
  'base.six_setting': ['a', 'b']
  'second.first_setting': false
  'second.second_setting': BBB
YAML

route "root :to => 'admin/dashboard#index'"

rake 'db:migrate'
rake 'db:test:prepare'
