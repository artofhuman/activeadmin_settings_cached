desc 'Creates a test rails app for the specs to run against'
task :setup do
  require 'rails/version'
  if File.exists? dir = "spec/rails/rails-#{Rails::VERSION::STRING}"
    puts "test app #{dir} already exists; skipping"
  else
    system 'mkdir -p spec/rails'

    args = %w[
      -m\ spec/support/rails_template.rb
      --skip-gemfile
      --skip-bundle
      --skip-git
      --skip-keeps
      --skip-turbolinks
      --skip-test-unit
      --skip-spring
    ]

    system "bundle exec rails new #{dir} #{args.join ' '}"
  end
end
