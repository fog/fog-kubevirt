require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :spec

task spec: 'tests:spec'

namespace :tests do
  desc 'Run fog-kubevirt spec/'
  Rake::TestTask.new do |t|
    t.name = 'spec'
    t.libs.push %w[lib spec]
    t.pattern = 'spec/unit/*_spec.rb'
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.libs.push %w[lib spec]
    t.name = 'integration'
    t.warning = true
    t.test_files = FileList['spec/integration/*_spec.rb']
  end
end

