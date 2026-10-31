# frozen_string_literal: true

desc 'Creates a test rails app for the specs to run against'
task :setup do
  require 'rails/version'
  if File.exist? dir = "spec/rails/rails-#{Rails::VERSION::STRING}"
    puts "test app #{dir} already exists; skipping"
  else
    system 'mkdir -p spec/rails'

    args = %w[
      -m\ spec/support/rails_template.rb
      --minimal
      --skip-bundle
      --skip-git
      --skip-test
      --skip-asset-pipeline
    ]

    system "bundle exec rails new #{dir} #{args.join ' '}"
  end
end
