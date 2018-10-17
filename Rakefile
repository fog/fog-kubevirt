require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :spec

task spec: 'tests:spec'

namespace :tests do
  desc 'Run fog-kubevirt spec/'
  Rake::TestTask.new do |t|
    t.name = 'spec'
    t.libs.push %w[lib spec]
    t.pattern = 'spec/**/*_spec.rb'
    t.verbose = true
  end
end

