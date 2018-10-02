require 'fog/kubevirt'

class Kubevirt
  #
  # Connects to kubevirt
  #
  def connect
    token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3N'\
	    'lcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1'\
            'lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9'\
	    'zZWNyZXQubmFtZSI6Im15LWFjY291bnQtdG9rZW4tN3QyNW4iLCJrdWJlcm5ldGV'\
	    'zLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibXktYWN'\
            'jb3VudCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2N'\
	    'vdW50LnVpZCI6IjkxNGNlOWM3LTE3YjktMTFlOC1hOWY5LTUyNTQwMGE3ZjY0NyI'\
	    'sInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0Om15LWFjY291bnQ'\
	    'ifQ.f5mbcgSjTOsBKPx7z-gckwMT_q3Bc3m6y6eNxQkytEGPF7Gv_pCTZ-ht8fod'\
	    'wpCZnzfQySRAQXDmB0UDcGajyzPRrwVJTvoEG01XiAlllQQ-p0RQetjNM86dJnoK'\
	    'rnvwV2Rmn2Kd-3aQqMhVeVXVUHz0eod42ob3mU7pvB-lZ4NUlgw5XMgM4e4wlNVV'\
	    'fk6MDKZlQHRpM2ZPBOk_lOtO6BhbKiGmEaYLD6Ul6AouqPTssjrn57zU4YNN26fv'\
	    'z4_7JaATqOjtt5Qk-LaPAenpYW44KDlUed6Dm_KvVsxD5fEBoBRu4RO8P2A5sy66'\
	    'Y-Qp7YlRX5VNrJ7BLQen-Vz1vQ'
    @conn = Fog::Kubevirt::Compute.new(:kubevirt_hostname => '192.168.121.121',
                             :kubevirt_port     => '8443',
                             :kubevirt_token    => token)
  end

  #
  # Fetches a collection of available templates in a namespace
  #
  def templates
    @conn.templates
  end

  #
  # Fetches specific template identified by name
  #
  # @param name Name of a template to fetch
  #
  def template(name)
    templates.get(name)
  end

  #
  # Fetches a collection of available vms in a namespace
  #
  def vms
    @conn.vms
  end

  #
  # Fetches specific vm identified by name
  #
  # @param name Name of a vm to fetch
  #
  def vm(name)
    vms.get(name)
  end

  #
  # Fetches a collection of available vms in a namespace
  #
  def vminstances
    @conn.vminstances
  end

  #
  # Fetches specific vm identified by name
  #
  # @param Name of a vm to fetch
  #
  def vminstance(name)
    vminstances.get(name)
  end
end

vm_name = 'fog-demo'

kube = Kubevirt.new
kube.connect

template = kube.template('working')
template.clone(name: vm_name, memory: 512)
vm = kube.vm(vm_name)
vm.start
kube.vminstance(vm_name)
