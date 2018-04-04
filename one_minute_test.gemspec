# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'one_minute_test/version'

Gem::Specification.new do |spec|
  spec.name          = "one_minute_test"
  spec.version       = OneMinuteTest::VERSION
  spec.authors       = ["jesusalc"]
  spec.email         = ["jesusalc@gmail.com"]

  spec.summary       = %q{A small ruby gem that exposes a cli to check status of a website.}
  spec.description   = %q{After probing the website for one minute every ten seconds it prints the average response time.}
  spec.homepage      = "https://gitlab.com/jesusalc/one_minute_test"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "thor", "~> 0.20"
end
