# frozen_string_literal: true
# Rails template to build the sample app for specs

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

create_file 'app/assets/config/manifest.js', <<-JS
//= link_tree ../images
//= link active_admin.css
//= link active_admin.js
JS

generate :'active_admin:install', '--skip-users'
generate :'settings:install'

# Both generators can create migrations within the same second
Dir[File.join(destination_root, 'db/migrate/*_create_settings.rb')].each do |file|
  File.rename(file, file.sub(/\d{14}(?=_create_settings)/) { |version| (version.to_i + 1).to_s })
end

# Configure Setup
inject_into_file 'config/initializers/active_admin.rb', <<-RUBY, before: "ActiveAdmin.setup do |config|"
ActiveadminSettingsCached.configure do |config|
  config.model_name = 'Setting'
end

RUBY

create_file 'app/models/setting.rb', <<-RUBY, force: true
class Setting < RailsSettings::Base
  field :app_name, default: 'AAA'

  scope :base do
    field :title, default: 'BBB', validates: { length: { maximum: 10 } }
    field :captcha_enabled, type: :boolean, default: true
    field :user_limit, type: :integer, default: 5
    field :tax_rate, type: :float, default: 5.5
    field :default_locale, default: 'en', option_values: %w[en de ru], help_text: 'Interface language'
  end

  scope :second do
    field :admin_emails, type: :array, default: %w[a@example.com b@example.com]
    field :notification_options, type: :hash, default: { 'send_all' => true }
    field :secret, default: 'hidden', readonly: true
  end
end
RUBY

route "root :to => 'admin/dashboard#index'"

rake 'db:migrate'
rake 'db:migrate', env: 'test'
