# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeadmin_settings_cached/version'

Gem::Specification.new do |spec|
  spec.name          = "activeadmin_settings_cached"
  spec.version       = ActiveadminSettingsCached::VERSION
  spec.authors       = ["Semyon Pupkov"]
  spec.email         = ["semen.pupkov@gmail.com"]
  spec.summary       = %q{UI interface for rails-settings-cached in active admin}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activeadmin', '1.0.0.pre'
  spec.add_dependency 'rails-settings-cached'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
