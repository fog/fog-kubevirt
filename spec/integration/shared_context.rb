require 'minitest/autorun'
require 'fog/core'
require 'fog/kubevirt'

class KubevirtConnection

  def initialize(options={})
    @host = ENV.key?('KUBE_HOST') ? ENV['KUBE_HOST'] : options[:host]
    @port = ENV.key?('KUBE_PORT') ? ENV['KUBE_PORT'] : options[:port]
    @token = ENV.key?('KUBE_TOKEN') ? ENV['KUBE_TOKEN'] : options[:token]
    @namespace = ENV.key?('KUBE_NAMESPACE') ? ENV['KUBE_NAMESPACE'] : options[:namespace]
  end

  def client
    if !ENV.key?('KUBECONFIG') 
      return Fog::Kubevirt::Compute.new(
        :kubevirt_hostname  => @host,
        :kubevirt_port      => @port,
        :kubevirt_token     => @token,
        :kubevirt_namespace => @namespace
      )
    else
      return Fog::Kubevirt::Compute.new(
        :kubevirt_token     => nil,
        :kubevirt_namespace => @namespace
      )
    end
  end
end