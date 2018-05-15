# Unreleased

## Fixed
- Breaking change in dry-types: Rename Types::Form to Types::Params (Julien FLAJOLLET)

# v2.2.0 2017-12-22

## Added

- Add `after_save` callback (Alexander Merkulov)

# v2.1.1 2017-08-07

## Fixed

- Fix generator (Alexander Merkulov)
- Fix i18n label content and 'for' attribute (Tom Richards)

# v2.1.0 2016-12-16

## Added

- Allow to use key option to configure `starting_with` option name (Alexander Merkulov)
- German translation (Flyte222)

## Changed

- Default model name is `Setting` instead `Settings`

# v2.0.1 2016-04-25

- Freeze right border for `rails-settings-cached` to `< 0.5.5`

# v2.0.0 2016-04-25

## Added

- Added DSL and multiply settings panels functionality (Alexander Merkulov)

## Changed

- Simplify localization, example

```
en:
  settings:
    attributes:
      my_awesome_settings: 'My Awesome Lolaized Setting'
```

# v1.0.1 2015-10-25

## Fixed

- Fix show settings in admin

# v1.0.0 2015-09-29

## Added

- Allow to configure how display options

# v0.1.0 2015-08-31

## Added

- Added labels to form fields (Derek Kniffin)

# v0.1.0 2015-08-03

## Added

- Show flash message after save settings

## Fixed

- Use proc for display settings name (Dmitry Krakosevich)

# v0.0.5 2015-06-04

## Fixed

- Display settings name if translation is missing (Lunar Farside)

# v0.0.4 2015-05-17

## Added

- Added en local (dixalex)

# v0.0.3 2015-04-30

## Fixed

- Unlock Active Admin dependency

# v0.0.2 2014-11-30

## Fixed

- Fix Active Admin version

# v0.0.1 2014-11-30

First public release
