# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/kubevirt/version'

Gem::Specification.new do |spec|
  # Dynamically create the authors information {name => e-mail}
  authors_hash = Hash[`git log --no-merges --reverse --format='%an,%ae'`.split("\n").uniq.collect {|i| i.split(",")}]
  # Fog maintainer
  authors_hash["Wesley Beary"] = "geemus@gmail.com"

  spec.name          = 'fog-kubevirt'
  spec.version       = Fog::Kubevirt::VERSION
  spec.authors       = authors_hash.keys
  spec.email         = authors_hash.values
  spec.summary       = "Module for the 'fog' gem to support Kubevirt."
  spec.description   = 'This library can be used as a module for `fog`.'
  spec.homepage      = 'https://github.com/pkliczewski/fog-kubevirt'
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -- lib/*`.split("\n")
  spec.files        += %w[README.md LICENSE.txt]
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  # spec.test_files   += %w[.rspec]
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency 'webmock'

  spec.add_dependency("fog-core", "~> 1.45")
  spec.add_dependency("kubeclient", "~> 2.5.2")
end
