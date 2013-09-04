# -*- ruby -*-
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
Rubocop::RakeTask.new do |task|
  task.patterns = [
    'lib/**/*.rb',
    'spec/**/*.rb'
  ]
end

task :all => [:spec, :rubocop]

task :default => :all
