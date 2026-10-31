# Activeadmin Settings Cached

[![Gem Version](https://badge.fury.io/rb/activeadmin_settings_cached.svg)](http://badge.fury.io/rb/activeadmin_settings_cached)
[![CI](https://github.com/artofhuman/activeadmin_settings_cached/actions/workflows/ci.yml/badge.svg)](https://github.com/artofhuman/activeadmin_settings_cached/actions/workflows/ci.yml)

Provides a nice UI interface for [rails-settings-cached](https://github.com/huacnlee/rails-settings-cached) gem in [Active Admin](http://activeadmin.info/).

Version 3 supports rails-settings-cached v2 (`>= 2.8.2`). For rails-settings-cached `< 0.6.7` use version 2.x of this gem.

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

And define your fields in your Setting model:

``` ruby
class Setting < RailsSettings::Base
  field :app_name, default: 'My app'

  scope :mail do
    field :admin_emails, type: :array, default: %w[admin@example.com]
    field :notifications_enabled, type: :boolean, default: true
    field :default_locale, default: 'en', option_values: %w[en de ru], help_text: 'Language of emails'
  end

  field :api_key, default: ENV['API_KEY'], readonly: true
end
```

In your application's admin interface, there will now be a new page with these settings.

Every editable field is shown. Readonly fields are not shown. Fields are grouped by `scope`.
The input depends on the field `type`:

Type                               | Input
---------------------------------- | -----
`:string`                          | text field
`:integer`, `:float`, `:big_decimal` | number field
`:boolean`                         | checkbox
`:array`                           | textarea, one value per line
`:hash`                            | textarea with YAML

A field with `option_values` is shown as a select. A field with `help_text` shows it as a hint.
Validation errors from `validates` are shown in the flash message.
Only changed values are saved, so unchanged fields keep their default value.

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
:scope			|Symbol, Array of Symbols, show only fields from these scopes (default: nil, all fields)
:template				|String, custom template rendering (default: 'admin/settings/index')
:template_object				|object passing to view (default: ActiveadminSettingsCached::Model instance)
:display    |Hash, display settings override (default: {})
:title			|String, title value override (default: I18n.t('settings.menu.label'))
:after_save |Proc, callback for action after POST request, (default: nil)

#### Settings on different pages

```ruby
ActiveAdmin.register_page 'Mail Settings' do
  active_admin_settings_page(scope: :mail, title: 'Mail Settings')
end
```

## Localization
You can localize settings keys in local file

``` yml
en:
  settings:
    attributes:
      my_awesome_settings: 'My Awesome Localized Setting'
    scopes:
      mail: 'Mail'
```
## Model name

By default the name of the mode is `Setting`. If you want to use a different name for the model, you can specify your that in `config/initializers/active_admin_settings_cached.rb`:

``` ruby
ActiveadminSettingsCached.configure do |config|
  config.model_name = 'AdvancedSetting'
end
```

## Display options

If you need to override the input for a field, eg textarea, url or :timestamp and etc., you can set `display` option in initializer.


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
cd spec/rails/rails-8.0.*/
BUNDLE_GEMFILE=/app/gemfiles/rails8.0.gemfile bundle exec rails s -b 0.0.0.0
```

## Upgrading from 2.x

- Update rails-settings-cached to v2 and define your settings with `field`.
- `starting_with` and `key` options are removed. Use rails-settings-cached `scope` and the `scope` option.
- Values are coerced by rails-settings-cached field types. `display` only changes the input.
