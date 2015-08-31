# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeadmin_settings_cached/version'

Gem::Specification.new do |s|
  s.name          = "activeadmin_settings_cached"
  s.version       = ActiveadminSettingsCached::VERSION
  s.authors       = ["Semyon Pupkov"]
  s.email         = ["semen.pupkov@gmail.com"]
  s.summary       = "UI interface for rails-settings-cached in active admin"
  s.description   = "UI interface for rails-settings-cached in active admin"
  s.homepage      = "https://github.com/artofhuman/activeadmin_settings_cached"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'activeadmin'
  s.add_dependency 'rails-settings-cached'

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
end
