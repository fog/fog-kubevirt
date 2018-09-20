# Fog::Kubevirt

fog-kubevirt is an kubevirt provider for [fog](https://github.com/fog/fog).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-kubevirt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-kubevirt

## Usage

Require the gem:
```ruby
require 'fog/kubevirt'
```

Connect to kubevirt instance:
```ruby

compute = Fog::Kubevirt::Compute.new
          :kubevirt_token  => token,
          :kubevirt_server => server,
          :kubevirt_port   => port
      )
```

## Contributing

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Please refer to [LICENSE.txt](LICENSE.txt).
