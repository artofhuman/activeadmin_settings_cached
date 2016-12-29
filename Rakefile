require 'bundler'
require 'rake'
Bundler.setup
Bundler::GemHelper.install_tasks

# Import all our rake tasks
FileList['tasks/**/*.rake'].each { |task| import task }

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.ruby_opts = %w[]
  t.verbose = false
end

desc 'Default: run the rspec examples'
task :default => [:spec]
