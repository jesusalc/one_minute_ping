require 'one_minute_test/version'
require 'thor'
require 'one_minute_test'
require 'http'
require 'sniffer'
require 'one_minute_test_helper'

# This the main procedure. Expects one string for website
# name pings and outputs average response time.
module OneMinuteTest
  # Uses help from the thor gem
  class CLI < Thor
    desc 'site [website]', 'website name like https://www.gitlab.com'
    def site(website)
      @website = website
      time_start = Time.now
      Sniffer.enable!
      @mean_list = OneMinuteTestHelper.check_status do
        OneMinuteTestHelper.hide_stdout { HTTP.get(@website) }
      end
      Sniffer.disable!
      elapsed_time = OneMinuteTestHelper.millis_diff(time_start, Time.now)
      OneMinuteTestHelper.puts_output elapsed_time, @website, @mean_list
    end
  end
end
