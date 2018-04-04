require 'walter/version'
require 'thor'
require 'walter'
require 'http'
require 'sniffer'
require 'rufus-scheduler'


module Walter
  class CLI < Thor
    desc "prob [website]", "prob any site for 1 minute with 10 second intervals"
    def prob(website)
      Sniffer.enable!
      scheduler = Rufus::Scheduler.new
      hide_stdout = -> do
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
      #
      # p Sniffer.data[0].to_h.last
      # Sniffer.data[0].response.timing
      # Sniffer.data[1].response.status
      milliseconds_start = Time.now
      count = 0
      6.times do
        puts "PROB" + count.to_s
        scheduler.in '10s' do
          # hide_stdout.() do
            HTTP.get(website)
          # end
        end
        scheduler.join
        count += 10
      end
      milliseconds_difference = -> start, finish { Time.at((finish - start) * 1000.0).strftime("%M:%S").to_s }
      elapsed_time = milliseconds_difference.(milliseconds_start,  Time.now)
      puts "Elapsed time: " + elapsed_time
      Sniffer.disable!
    end
  end

end
