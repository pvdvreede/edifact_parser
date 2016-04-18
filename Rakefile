# -*- ruby -*-
require 'rake/testtask'

task :compile do
  sh "racc -v -g -l -o lib/edifact_parser/parser.rb lib/edifact_parser/parser.y"
end

task :test => :compile do
  Rake::TestTask.new do |t|
    t.pattern = 'test/**/test_*.rb'
    t.verbose = true
  end
end

desc "Run tests"
task :default => :test
