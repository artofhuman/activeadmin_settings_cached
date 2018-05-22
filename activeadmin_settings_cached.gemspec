# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeadmin_settings_cached/version'

Gem::Specification.new do |s|
  s.name          = 'activeadmin_settings_cached'
  s.version       = ActiveadminSettingsCached::VERSION
  s.authors       = ['Semyon Pupkov']
  s.email         = ['mail@semyonpupkov.com']
  s.summary       = 'UI interface for rails-settings-cached in active admin'
  s.description   = 'UI interface for rails-settings-cached in active admin'
  s.homepage      = 'https://github.com/artofhuman/activeadmin_settings_cached'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'activeadmin'
  s.add_dependency 'dry-types', '>= 0.13.0'
  s.add_dependency 'rails-settings-cached', '>= 0.5.3', '< 0.6.7'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'sqlite3'
end
