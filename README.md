# Activeadmin Settings Cached

[![Gem Version](https://badge.fury.io/rb/activeadmin_settings_cached.svg)](http://badge.fury.io/rb/activeadmin_settings_cached)

Gem for Rails provides ui interface for rails-settings-cached gem in Active Admin 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeadmin_settings_cached'
```

And then execute:

    $ bundle

Create you settings model:

    $ rails g settings Settings
    $ bundle exec rake db:migrate

Add route in config/routes.rb

``` ruby
ActiveAdmin.routes(self)
mount ActiveadminSettingsCached::Engine => '/admin' 
```

And configure you default values in model Settings like this:

``` ruby
class Settings < RailsSettings::CachedSettings
   defaults[:my_awesome_settings] = 'This is my settings'
end
```

And in your appication admin avaliable new page with this settings

# Localization
You can localize settings keys in local file

``` yml
en:
  settings:
    attributes:
      my_awesome_settings:
        name: 'My Awesome Lolaized Setting'
```

If you settings model named not Settings, you can define model name in
`config/initializers/active_admin_settings_cached.rb`

``` ruby
ActiveadminSettingsCached.settings_class = 'AdvancedSetting'
```

For how use Settings in you application see documentation fo rails-settings-cached gem https://github.com/huacnlee/rails-settings-cached
