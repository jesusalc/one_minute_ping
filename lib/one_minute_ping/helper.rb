# Helper class to use be used by OneMinutePing module
class Helper
  def self.seconds_diff(start, finish)
    (finish - start) / 1000.0
  end

  def self.millis_diff(start, finish)
    (finish - start) * 1000.0
  end

  def self.check_status
    access_index = 0
    mean_list = []
    6.times do
      deduction_time_start = Time.now
      yield
      if !Sniffer.data.nil? && !Sniffer.data[access_index].nil?
        mean_list.push(Sniffer.data[access_index].response.timing)
      end
      access_index += 1
      wait_time(deduction_time_start, 10_000.00)
    end
    mean_list
  end

  def self.wait_time(deduction_time_start, ten_milliseconds)
    deduction_elapsed_time = millis_diff(deduction_time_start, Time.now)
    duration = seconds_diff(ten_milliseconds, deduction_elapsed_time).abs
    sleep duration
  end

  def self.seconds(milliseconds)
    (milliseconds / 1000).round(3)
  end

  def self.millis_rounded(milliseconds)
    (milliseconds * 1000).round(3)
  end

  def self.puts_output(elapsed_time, website, mean_list)
    puts "\nServer Hostname:      " + website
    puts "\nTime taken for tests: " + seconds(elapsed_time).to_s +
         " seconds"
    puts "Time per request:     " + calculate_average(mean_list).to_s +
         " [ms] (mean, across all concurrent requests) \n\n"
  end

  def self.calculate_average(mean_list)
    millis_rounded(mean_list.inject(&:+).to_f / mean_list.size.to_f)
  end

  def self.begin_hide_stdout
    orig_stderr = $stderr.clone
    orig_stdout = $stdout.clone
    $stderr.reopen File.new("/dev/null", "w")
    $stdout.reopen File.new("/dev/null", "w")
    [orig_stderr, orig_stdout]
  end

  def self.hide_stdout
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
end
