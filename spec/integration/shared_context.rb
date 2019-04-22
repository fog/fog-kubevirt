require 'minitest/autorun'
require 'fog/core'
require 'fog/kubevirt'

class KubevirtConnection

  def initialize(options={})
    @host = ENV.key?('KUBE_HOST') ? ENV['KUBE_HOST'] : options[:host]
    @port = ENV.key?('KUBE_PORT') ? ENV['KUBE_PORT'] : options[:port]
    @token = ENV.key?('KUBE_TOKEN') ? ENV['KUBE_TOKEN'] : options[:token]
  end

  def client
    if !ENV.key?('KUBECONFIG') 
      return Fog::Kubevirt::Compute.new(:kubevirt_hostname => @host,
        :kubevirt_port     => @port,
        :kubevirt_token    => @token)
    else
      return Fog::Kubevirt::Compute.new(:kubevirt_token => nil)
    end
  end
end