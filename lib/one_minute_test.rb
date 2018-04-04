require 'one_minute_test/version'
require 'thor'
require 'one_minute_test'
require 'http'
require 'sniffer'

module OneMinuteTest
  class CLI < Thor

    desc "site [website]", "website name like https://gitlab.com or https://about.gitlab.com "
    def site(website)
      milliseconds_difference = -> start, finish { (finish - start) * 1000.0 }
      seconds_difference = -> start, finish { (finish - start) / 1000.0 }
      milliseconds_start = Time.now
      access_index = 0
      ten_milliseconds = 10000.00
      mean_list = []

      Sniffer.enable!

      6.times do
        deduction_milliseconds_start = Time.now
        hide_stdout { HTTP.get(website) }
        mean_list << Sniffer.data[access_index].response.timing
        access_index += 1
        deduction_elapsed_time = milliseconds_difference.(deduction_milliseconds_start,  Time.now)
        duration = seconds_difference.(ten_milliseconds, deduction_elapsed_time).abs
        sleep duration
      end

      Sniffer.disable!
      elapsed_time = milliseconds_difference.(milliseconds_start,  Time.now)
      output mean_list, elapsed_time, website
    end

    private

    def output(mean_list, elapsed_time, website)
      seconds = -> milliseconds { (milliseconds / 1000).round(3) }
      rounded_milliseconds = -> milliseconds { (milliseconds * 1000).round(3) }

      puts ""
      puts "Server Hostname:      " + website
      puts ""
      puts "Time taken for tests: " + seconds.(elapsed_time).to_s + " seconds"
      average = (mean_list.inject(&:+).to_f) / mean_list.size.to_f
      puts "Time per request:     " +  rounded_milliseconds.(average).to_s + " [ms] (mean, across all concurrent requests)"
      puts ""
    end

    def hide_stdout
      begin
        orig_stderr = $stderr.clone
        orig_stdout = $stdout.clone
        $stderr.reopen File.new('/dev/null', 'w')
        $stdout.reopen File.new('/dev/null', 'w')
        return_value = yield
      rescue Exception => e
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
        raise e
      ensure
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
      end
      return_value
    end
  end

end
