require 'vcr'

FAKE_HOST = "10.8.254.82"
FAKE_PORT = "8443"
FAKE_NAMESPACE = "default"

class KubevirtVCR
	attr_reader :service,
	            :host,
	            :port,
	            :token

  def initialize(options)
    @vcr_directory = options[:vcr_directory]
    @service_class = options[:service_class]

    use_recorded = !ENV.key?('KUBE_HOST') || ENV['USE_VCR'] == 'true'
    if use_recorded
      Fog.interval = 0
      @host = FAKE_HOST
      @port = FAKE_PORT
      @namespace = FAKE_NAMESPACE
    else
      @host = ENV['KUBE_HOST']
      @port = ENV['KUBE_PORT']
      @namespace = ENV['KUBE_NAMESPACE']
    end

    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
      config.hook_into :webmock

      if use_recorded
        config.cassette_library_dir = ENV['SPEC_PATH'] || @vcr_directory
        config.default_cassette_options = {:record => :none}
        config.default_cassette_options.merge! :match_requests_on => %i[method uri body]
      else
        config.cassette_library_dir = "spec/debug"
        config.default_cassette_options = {:record => :all}

        config.filter_sensitive_data('Bearer <TOKEN>') do |interaction|
          interaction.request.headers['Authorization']&.first
        end
        config.filter_sensitive_data(FAKE_HOST) { @host }
        config.filter_sensitive_data(FAKE_PORT) { @port }
        config.filter_sensitive_data(FAKE_NAMESPACE) { @namespace } if @namespace != FAKE_NAMESPACE
      end
    end

    VCR.use_cassette('common_setup') do
      @token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im15LWFjY291bnQtdG9rZW4ta3FsZDYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibXktYWNjb3VudCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjJlYjVjZjU1LTFlNDUtMTFlOS1iYmZmLWZhMTYzZTM4OTEyYSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0Om15LWFjY291bnQifQ.aAigSXFZapxJdFy3FwgSNc77jZYFiSTlG7D_AnHzBT1ZP69xLmrqI_oXt73NDLpecNWezjIvsCU6sLf45tfPY2RQX_aEAOXKWjFs2SxWI7GeQ-sWRt0yd1sOB9R48ipTdpNpNs5pypnTRg6dYLvtePmBWyOSN2412F9XKeM79tuO9a_ynPDjkCwsWJXGj-gX9DwpHdGK-cup0YosJ-9OpvXoWOiUNeBi1KrvJxgQwgLytJk3PHFnJHv4mCNALvvo1cu89_ENwUQrvok267ACeq53YsivYn7B0QWuZoX3ca4Bx14kEdXbd-9BvIEBZzVovH2ZvPTYMmyXgnpO7c1eOw"

      unless use_recorded
        @token = ENV['KUBE_TOKEN'] || options[:token] || @token
      end

      connection_params = {
        kubevirt_hostname: @host,
        kubevirt_port: @port,
        kubevirt_token: @token,
        kubevirt_namespace: @namespace,
        kubevirt_verify_ssl: false,
      }

      @service = @service_class.new(connection_params)
    end
  end
end
