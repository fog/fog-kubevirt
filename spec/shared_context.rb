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
      @host = "192.168.122.51"
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
      @token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJldmlydC1wcml2aWxlZ2VkLXRva2VuLW1xN252Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6Imt1YmV2aXJ0LXByaXZpbGVnZWQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJjNGQyODA4MS1jZDNlLTExZTgtOGYzYy1hYzAxYzZkMzhmZWIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06a3ViZXZpcnQtcHJpdmlsZWdlZCJ9.BUBWJi9a_A_rOrsiil7wEqxxdDOtpYt9M42HHdQr0JQ5Y2ES5xI2yecpdXPypfX4wa-8blj7xJyU3EZCSTUUX2Z-KXoYieYr6sKB-umYiK4MR4eSiBFL8J0QP_2zxZleUOAuAT8JZCHh7JbccUM0ebOtNPBCVDPb_j-zSsuSISBtayGzTzo7RgkyyO_2NfyYBv1b3gxlznGsWuqw6Kw01OE5Xs7EIDAbGn6Z51NUU3fE_UGZg5588z_WurEV_tJhfDGBIuIsWaJHHTmwnQ6kll4nWaqV5r3NlrSmk_z5m14rlmDRf2G-oTMkFlHgDjTbkZeUF8G0TT4FShQzrWSFhA"

      unless use_recorded
        @token = ENV['KUBE_TOKEN'] || options[:token] || @token
      end

      connection_params = {
        provider: 'kubevirt',
        kubevirt_hostname: @host,
        kubevirt_port: @port,
        kubevirt_token: @token
      }

      @service = @service_class.new(connection_params)
    end
  end
end