require_relative './spec_helper'
require 'fog/kubevirt/compute/models/secret'

describe Fog::Kubevirt::Compute::Secret do
  describe '.parse' do
    it 'parses a secret with metadata, data and type' do
      object = {
        metadata: {
          name: 'shim-test',
          namespace: 'rhv-sshtein',
          uid: 'b64ca739-8d66-4c98-831b-5a18d24ca2cf',
          resourceVersion: '11565639627',
          creationTimestamp: '2026-02-25T11:42:02Z'
        },
        data: { :'secret-key' => 'U2ltcGxlIHRleHQgc2VjcmV0' },
        type: 'Opaque'
      }

      result = Fog::Kubevirt::Compute::Secret.parse(object)

      assert_equal 'shim-test', result[:name]
      assert_equal 'rhv-sshtein', result[:namespace]
      assert_equal '11565639627', result[:resource_version]
      assert_equal 'b64ca739-8d66-4c98-831b-5a18d24ca2cf', result[:uid]
      assert_equal '2026-02-25T11:42:02Z', result[:creation_timestamp]
      assert_equal({ :'secret-key' => 'U2ltcGxlIHRleHQgc2VjcmV0' }, result[:data])
      assert_equal 'Opaque', result[:type]
    end

    it 'handles missing metadata and data gracefully' do
      result = Fog::Kubevirt::Compute::Secret.parse({})

      assert_nil result[:name]
      assert_nil result[:namespace]
      assert_equal({}, result[:data])
      assert_nil result[:type]
    end

    it 'handles nil data' do
      result = Fog::Kubevirt::Compute::Secret.parse(metadata: { name: 'foo' }, data: nil, type: 'Opaque')

      assert_equal 'foo', result[:name]
      assert_equal({}, result[:data])
      assert_equal 'Opaque', result[:type]
    end
  end
end
