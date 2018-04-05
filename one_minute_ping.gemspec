
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "one_minute_ping/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name = "one_minute_ping"
  spec.version = OneMinutePing::VERSION
  spec.authors = ["jesusalc"]
  spec.email = ["jesusalc@gmail.com"]

  spec.summary = "Exposes a cli to check website average load."
  spec.description = "Pings the website for one minute each 10 seconds."
  spec.homepage = "https://gitlab.com/jesusalc/one_minute_ping"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either
  # set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency 'coveralls',  '~> 0.8.21'
  spec.add_development_dependency "deep-cover"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
  spec.add_dependency "http"
  spec.add_dependency "sniffer"
  spec.add_dependency "thor", "~> 0.20"
end
# rubocop:enable Metrics/BlockLength
