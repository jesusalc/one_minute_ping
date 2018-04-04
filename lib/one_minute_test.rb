require 'one_minute_test/version'
require 'thor'
require 'one_minute_test'
require 'http'
require 'sniffer'

# This the main procedure. Expects one string for website
# name pings and outputs average response time.
module OneMinuteTest
  # Uses help from the thor gem
  class CLI < Thor
    desc 'site [website]', 'website name like https://www.gitlab.com'
    def site(website)
      @website = website
      milliseconds_start = Time.now
      @ten_milliseconds = 10_000.00
      Sniffer.enable!
      @mean_list = check_status do
        hide_stdout { HTTP.get(@website) }
      end
      Sniffer.disable!
      elapsed_time = millis_diff(milliseconds_start, Time.now)
      puts_output elapsed_time
    end

    private

    def seconds_diff(start, finish)
      (finish - start) / 1000.0
    end

    def millis_diff(start, finish)
      (finish - start) * 1000.0
    end

    def check_status
      access_index = 0
      mean_list = []
      6.times do
        deduction_time_start = Time.now
        yield
        mean_list.push(Sniffer.data[access_index].response.timing)
        access_index += 1
        wait_time(deduction_time_start)
      end
      mean_list
    end

    def wait_time(deduction_time_start)
      deduction_elapsed_time = millis_diff(deduction_time_start, Time.now)
      duration = seconds_diff(@ten_milliseconds, deduction_elapsed_time).abs
      sleep duration
    end

    def seconds(milliseconds)
      (milliseconds / 1000).round(3)
    end

    def millis_rounded(milliseconds)
      (milliseconds * 1000).round(3)
    end

    def puts_output(elapsed_time)
      puts "\nServer Hostname:      " + @website
      puts "\nTime taken for tests: " + seconds(elapsed_time).to_s +
           ' seconds'
      puts 'Time per request:     ' + calculate_average.to_s +
           " [ms] (mean, across all concurrent requests) \n"
    end

    def calculate_average
      millis_rounded(@mean_list.inject(&:+).to_f / @mean_list.size.to_f)
    end

    def begin_hide_stdout
      orig_stderr = $stderr.clone
      orig_stdout = $stdout.clone
      $stderr.reopen File.new('/dev/null', 'w')
      $stdout.reopen File.new('/dev/null', 'w')
      [orig_stderr, orig_stdout]
    end

    # rubocop:disable Metrics/MethodLength
    def hide_stdout
      begin
        orig_stderr, orig_stdout = begin_hide_stdout
        return_value = yield
      rescue StandardError => e
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
        raise e
      ensure
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
      end
      return_value
    end
    # rubocop:enable Metrics/MethodLength
  end
end
