# Helper class to use be used by OneMinutePing module
class Helper
  # rubocop:disable Metrics/AbcSize
  def self.check_status
    i = 0
    responses = []
    6.times do
      deduction_time_start = Time.now
      yield
      responses.push(Sniffer.data[i].response.status => Sniffer.data[i].response.timing) if !Sniffer.data.nil? && !Sniffer.data[i].nil?
      i += 1
      wait_time(deduction_time_start, 10_000.00)
    end
    responses
  end

  def self.calculate_average(responses)
    total_avg = millis_rounded(responses.map(&:first).map(&:last).inject(&:+).to_f / responses.size.to_f)
    averages = { total_avg: total_avg, count: responses.size, group: {}, results: {} }
    responses.each do |response|
      response.keys.each do |key|
        if !averages[:group].key?(key)
          averages[:group][key] = [response[key]]
        else
          averages[:group][key].push(response[key])
        end
      end
    end
    averages[:group].keys.sort.each do |key|
      averages[:results][key] = millis_rounded(averages[:group][key].inject(&:+).to_f / averages[:group][key].size.to_f)
    end
    averages
  end

  # rubocop:enable Metrics/AbcSize
  #
  def self.view(time_start, website, responses)
    elapsed_time = Helper.millis_diff(time_start, Time.now)
    puts Helper.construct_output Helper.seconds(elapsed_time), website, Helper.calculate_average(responses)
  end

  def self.seconds_diff(start, finish)
    (finish - start) / 1000.0
  end

  def self.millis_diff(start, finish)
    (finish - start) * 1000.0
  end

  def self.wait_time(deduction_time_start, ten_milliseconds)
    deduction_elapsed_time = millis_diff(deduction_time_start, Time.now)
    duration = seconds_diff(ten_milliseconds, deduction_elapsed_time).abs
    sleep duration
  end

  def self.seconds(milliseconds)
    (milliseconds / 1000.0).round(3)
  end

  def self.millis_rounded(milliseconds)
    (milliseconds * 1000.0).round(3)
  end

  def self.construct_output(secs, website, averages)
    res = "\nServer Hostname:      #{website}" \
        "\n\nCounted requests:     #{averages[:count]}" \
          "\nTime taken for tests: #{secs} seconds\n"
    averages[:results].keys.each do |key|
      res += "\nTime for status #{key}:  #{averages[:results][key]}" \
               " [ms] (mean, only per all responses with status #{key})"
    end
    res + "\nTime per request:     #{averages[:total_avg]}" \
             " [ms] (mean, across all concurrent requests) \n\n"
  end

  def self.begin_hide_stdout
    orig_stderr = $stderr.clone
    orig_stdout = $stdout.clone
    $stderr.reopen File.new('/dev/null', 'w')
    $stdout.reopen File.new('/dev/null', 'w')
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
