require 'rake'
require 'rspec/core/rake_task'
require 'rake/testtask'

RSpec::Core::RakeTask.new(:spec)

Rake::TestTask.new do |t|
    require File.join __dir__,"test","test_helper.rb"
end

task :default => :spec
