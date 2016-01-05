# Rails template to build the sample app for specs

generate :settings, 'Setting'

# Configure default_url_options in test environment
inject_into_file 'config/environments/test.rb', "  config.action_mailer.default_url_options = { :host => 'example.com' }\n", after: "config.cache_classes = true\n"

# Add our local Active Admin to the load path
inject_into_file 'config/environment.rb', "\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire \"active_admin\"\n", after: "require File.expand_path('../application', __FILE__)"

run 'rm Gemfile'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

generate :'active_admin:install --skip-users'
generate :'formtastic:install'

# Configure Setup
inject_into_file 'config/initializers/active_admin.rb', "ActiveadminSettingsCached.configure do |config|\n  config.model_name = 'Setting'\nend\n", before: "ActiveAdmin.setup do |config|\n"

run 'rm -r test'
run 'rm -r spec'

route "root :to => 'admin/dashboard#index'"

rake 'db:migrate'
rake 'db:test:prepare'
