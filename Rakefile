require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task default: :spec

# RSpec::Core::RakeTask.new
RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = false
  t.rspec_opts = "--no-drb -r rspec_junit_formatter --format RspecJunitFormatter -o junit.xml"
end
