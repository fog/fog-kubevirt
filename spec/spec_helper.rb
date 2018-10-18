require 'minitest/autorun'
require 'vcr'
require 'fog/core'
require 'fog/kubevirt'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/kubevirt'
  c.hook_into :webmock
  c.debug_logger = nil # use $stderr to debug
end