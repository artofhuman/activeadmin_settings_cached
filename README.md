# Activeadmin Settings Cached

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

For how use Settings in you application see documentation fo rails-settings-cached gem https://github.com/huacnlee/rails-settings-cached
