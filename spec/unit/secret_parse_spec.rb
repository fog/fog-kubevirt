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

  describe '#persisted?' do
    it 'returns false when uid is nil' do
      secret = Fog::Kubevirt::Compute::Secret.new(name: 'x', uid: nil)
      assert_equal false, secret.persisted?
    end

    it 'returns false when uid is empty string' do
      secret = Fog::Kubevirt::Compute::Secret.new(name: 'x', uid: '')
      assert_equal false, secret.persisted?
    end

    it 'returns true when uid is present' do
      secret = Fog::Kubevirt::Compute::Secret.new(name: 'x', uid: 'b64ca739-8d66-4c98-831b-5a18d24ca2cf')
      assert_equal true, secret.persisted?
    end
  end

  describe '#to_secret_hash' do
    it 'builds API hash with name, namespace, data, type' do
      secret = Fog::Kubevirt::Compute::Secret.new(
        name: 'my-secret',
        namespace: 'myns',
        data: { key: 'dmFsdWU=' },
        type: 'Opaque'
      )
      h = secret.to_secret_hash
      assert_equal 'v1', h[:apiVersion]
      assert_equal 'Secret', h[:kind]
      assert_equal 'my-secret', h[:metadata][:name]
      assert_equal 'myns', h[:metadata][:namespace]
      assert_equal({ key: 'dmFsdWU=' }, h[:data])
      assert_equal 'Opaque', h[:type]
      assert_nil h[:metadata][:resourceVersion]
    end

    it 'includes resourceVersion when set' do
      secret = Fog::Kubevirt::Compute::Secret.new(
        name: 'my-secret',
        resource_version: '12345'
      )
      h = secret.to_secret_hash
      assert_equal '12345', h[:metadata][:resourceVersion]
    end
  end
end
