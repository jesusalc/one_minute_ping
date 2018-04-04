require 'walter/version'
require 'thor'
require 'walter'
require 'http'
require 'sniffer'


module Walter
  class CLI < Thor
    desc "prob [website]", "prob any site for 1 minute with 10 second intervals"
    def prob(website)
      Sniffer.enable!
      beginning_time = Time.now
      float_to_seconds_str = -> floaty { Time.at(floaty).strftime("%S") }
      float_to_milliseconds_str = -> floaty { Time.at(floaty).strftime("%L") }
      milliseconds_difference = -> start, finish { (finish - start) * 1000.0 }
      milliseconds_start = Time.now
      count = 0
      access_index = 0
      ten_milliseconds = 100.0000
      6.times do
        deduction_milliseconds_start = Time.now
        puts "Probing #{website} " + count.to_s
        hide_stdout do
          # ab -k -c 1 -n 1 -t 60 -s 10 https://www.gitlab.com/
          HTTP.get(website)
        end
          puts " +--- Response   time: " + float_to_milliseconds_str.((Sniffer.data[access_index].response.timing))
          puts " +--- Response status: " + Sniffer.data[access_index].response.status.to_s
        access_index += 1
        count += 10
        deduction_elapsed_time = milliseconds_difference.(deduction_milliseconds_start,  Time.now)
        duration = ((ten_milliseconds - deduction_elapsed_time) / 1000).abs
        puts " +-------------- Request time: " + (deduction_elapsed_time).to_s
        puts " +---------------  Pause time: " + (duration).to_s
        deduction_milliseconds_start = Time.now
        sleep duration
        deduction_elapsed_time = milliseconds_difference.(deduction_milliseconds_start,  Time.now)
        puts "                  Pause took: " + (deduction_elapsed_time).to_s
        p (deduction_elapsed_time)

      end
      elapsed_time = milliseconds_difference.(milliseconds_start,  Time.now)
      puts "Elapsed time: " + (elapsed_time).to_s
      Sniffer.disable!
      end_time = Time.now
      result = (end_time - beginning_time)*1000
      puts "Time elapsed #{result} milliseconds"
      puts "Time elapsed #{float_to_milliseconds_str.(result)} milliseconds"

    end
    private
    def hide_stdout
      begin
        orig_stderr = $stderr.clone
        orig_stdout = $stdout.clone
        $stderr.reopen File.new('/dev/null', 'w')
        $stdout.reopen File.new('/dev/null', 'w')
        retval = yield
      rescue Exception => e
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
        raise e
      ensure
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
      end
      retval
    end
  end

end
