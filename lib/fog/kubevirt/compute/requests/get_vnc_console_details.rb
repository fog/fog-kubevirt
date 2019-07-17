module Fog
  module Kubevirt
    class Compute
      class Real
        def get_vnc_console_details(name, namespace)

          url = URI::Generic.build(
              :scheme => 'https',
              :host   => @host,
              :port   => @port,
              :path   => "/apis/kubevirt.io"
          )
          version = detect_version(url.to_s, @opts[:ssl_options])
            {
             :host => @host,
             :port => @port,
             :path => "/apis/subresources.kubevirt.io/#{version}/namespaces/#{namespace}/virtualmachineinstances/#{name}/vnc",
             :token => @opts[:auth_options][:bearer_token]
            }
        end
      end

      class Mock
        def get_vnc_console_details(name, namespace)
        end
      end
    end
  end
end