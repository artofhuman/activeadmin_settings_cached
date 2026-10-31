# frozen_string_literal: true

require 'database_cleaner/active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path('../support', __FILE__)

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler'
Bundler.setup

ENV['RAILS_ENV'] = 'test'
# Ensure the Active Admin load path is happy
require 'rails'
ENV['RAILS'] = Rails.version
ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{ENV['RAILS']}", __FILE__)
# Create the test app if it doesn't exists
unless File.exist?(ENV['RAILS_ROOT'])
  system 'rake setup'
end

require ENV['RAILS_ROOT'] + '/config/environment.rb'
# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

require 'rspec/rails'
require 'support/admin'
require 'capybara/rails'
require 'capybara/rspec'

RSpec.configure do |config|
  DatabaseCleaner.strategy = :truncation

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Setting.clear_cache
  end
end
