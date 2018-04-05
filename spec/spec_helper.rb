ENV["TEST"] = "1"
require "deep-cover" # Must be before the environment is loaded on the next line
# require "deep_cover/builtin_takeover" # Must be before the environment is loaded on the next line
# require "simplecov"
# SimpleCov.start

require "pp"
require "open3"

root = File.expand_path("..", __dir__)
require "#{root}/lib/one_minute_ping"

module Helpers
  def execute(cmd)
    puts "Running: #{cmd}" if ENV["DEBUG"]
    stdout, stderr, status = Open3.capture3(cmd.to_s)
    puts stdout if ENV["DEBUG"]
    [stdout, stderr, status]
  end
end

RSpec.configure do |c|
  c.include Helpers
end
