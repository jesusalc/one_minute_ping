require 'thor'
require 'http'
require 'sniffer'
require './lib/one_minute_ping/version'
require './lib/one_minute_ping/helper'

# This the main procedure. Expects one string for website
# name pings and outputs average response time.
module OneMinutePing
  # Uses help from the thor gem
  class CLI < Thor
    desc 'for [website]', "website name like https://www.gitlab.com\n"
    def for(website)
      time_start = Time.now
      Sniffer.enable!
      mean_list = Helper.check_status do
        Helper.hide_stdout { HTTP.get(website) }
      end
      Sniffer.disable!
      Helper.view(time_start, website, mean_list)
    end
  end
end
