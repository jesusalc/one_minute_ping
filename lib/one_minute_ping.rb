require 'one_minute_ping/version'
require 'thor'
require 'one_minute_ping'
require 'http'
require 'sniffer'
require 'one_minute_ping/helper'

# This the main procedure. Expects one string for website
# name pings and outputs average response time.
module OneMinutePing
  # Uses help from the thor gem
  class CLI < Thor
    desc 'for [website]', "website name like https://www.gitlab.com\n"
    def for(website)
      @website = website
      time_start = Time.now
      Sniffer.enable!
      @mean_list = Helper.check_status do
        Helper.hide_stdout { HTTP.get(@website) }
      end
      Sniffer.disable!
      elapsed_time = Helper.millis_diff(time_start, Time.now)
      puts Helper.construct_output Helper.seconds(elapsed_time), @website, Helper.calculate_average(@mean_list)
    end
  end
end
