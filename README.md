# Activeadmin Settings Cached

[![Gem Version](https://badge.fury.io/rb/activeadmin_settings_cached.svg)](http://badge.fury.io/rb/activeadmin_settings_cached)

Provides a nice UI interface for [rails-settings-cached](https://github.com/huacnlee/rails-settings-cached) gem in [Active Admin](http://activeadmin.info/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeadmin_settings_cached'
```

And then execute:

    $ bundle

Create your settings model:

    $ rails g settings Settings
    $ bundle exec rake db:migrate

Add a route in config/routes.rb

``` ruby
ActiveAdmin.routes(self)
mount ActiveadminSettingsCached::Engine => '/admin' 
```

And configure your default values in your Settings model:

``` ruby
class Settings < RailsSettings::CachedSettings
   defaults[:my_awesome_settings] = 'This is my settings'
end
```

In your application's admin interface, there will now be a new page with this setting

## Localization
You can localize settings keys in local file

``` yml
en:
  settings:
    attributes:
      my_awesome_settings:
        name: 'My Awesome Lolaized Setting'
```
## Model name

By default the name of the mode is `Settings`. If you want to use a different name for the model, you can specify your that in `config/initializers/active_admin_settings_cached.rb`:

``` ruby
ActiveadminSettingsCached.settings_class = 'AdvancedSetting'
```
