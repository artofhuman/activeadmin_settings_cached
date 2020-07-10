# Activeadmin Settings Cached

[![Gem Version](https://badge.fury.io/rb/activeadmin_settings_cached.svg)](http://badge.fury.io/rb/activeadmin_settings_cached)
[![Build Status](https://travis-ci.org/artofhuman/activeadmin_settings_cached.svg?branch=master)](https://travis-ci.org/artofhuman/activeadmin_settings_cached)
[![Coverage Status](https://coveralls.io/repos/github/artofhuman/activeadmin_settings_cached/badge.svg?branch=master)](https://coveralls.io/github/artofhuman/activeadmin_settings_cached?branch=master)

Provides a nice UI interface for [rails-settings-cached](https://github.com/huacnlee/rails-settings-cached) gem in [Active Admin](http://activeadmin.info/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeadmin_settings_cached'
```

And then execute:

    $ bundle

Create your settings model:

    $ rails g settings:install
    $ bundle exec rake db:migrate

Create your settings page:

    # From generators                   
    $ rails g active_admin:settings Setting  
                 
    # Or manual

``` ruby
# app/admin/setting.rb
ActiveAdmin.register_page 'Setting' do
  title = 'Settings'
  menu label: title

  active_admin_settings_page(
    title: title
  )
end
```

And configure your default values in your Settings model:

``` ruby
class Settings < RailsSettings::CachedSettings
  defaults[:my_awesome_settings] = 'This is my settings'
end
```

In your application's admin interface, there will now be a new page with this setting

## active_admin_settings_page DSL

#### Basic usage

```ruby
ActiveAdmin.register_page 'Settings' do
  menu label: 'Settings', priority: 99
  active_admin_settings_page options
end
```

#### Options
Tool                    | Description
---------------------   | -----------
:model_name					|String, settings model name override (default: uses name from global config.)
:starting_with			|String, each key must starting with, (default: nil)
:key			|String, Symbol root key, can be replacement for starting_with, (default: nil)
:template				|String, custom template rendering (default: 'admin/settings/index')
:template_object				|object passing to view (default: ActiveadminSettingsCached::Model instance)
:display    |Hash, display settings override (default: {})
:title			|String, title value override (default: I18n.t('settings.menu.label'))
:after_save |Proc, callback for action after POST request, (default: nil)
 

## Localization
You can localize settings keys in local file

``` yml
en:
  settings:
    attributes:
      my_awesome_settings: 'My Awesome Localized Setting'
```
## Model name

By default the name of the mode is `Setting`. If you want to use a different name for the model, you can specify your that in `config/initializers/active_admin_settings_cached.rb`:

``` ruby
ActiveadminSettingsCached.configure do |config|
  config.model_name = 'AdvancedSetting'
end
```

## Display options

If you need define display options for settings fields, eg textarea, url or :timestamp and etc., you can set `display` option in initializer.


``` ruby
ActiveadminSettingsCached.configure do |config|
  config.display = {
    my_awesome_setting_name: :text,
    my_awesome_setting_name_2: :timestamp,
    my_awesome_setting_name_3: :select
  }
end
```

Available options see [here](https://github.com/justinfrench/formtastic#the-available-inputs)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## How run local example

```
make bash
make setup
cd spec/rails/rails-5.1.7/
BUNDLE_GEMFILE=/app/gemfiles/rails5.1.gemfile bundle exec rails s -b 0.0.0.0
```
