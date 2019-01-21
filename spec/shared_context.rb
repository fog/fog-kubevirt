require 'vcr'

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
      @host = "10.8.254.82"
      @port = "8443"
    else
      @host = ENV['KUBE_HOST']
      @port = ENV['KUBE_PORT']
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
        kubevirt_token: @token
      }

      @service = @service_class.new(connection_params)
    end
  end
end