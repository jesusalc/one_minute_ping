require 'spec_helper'

# to run specs with what"s remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
describe OneMinutePing::CLI do
  before(:all) do
    @args = 'for'
  end

  describe 'one_minute_ping' do
    it '#for missing [website] shows command tip' do
      out = execute("exe/one_minute_ping #{@args}")
      expect(out).to \
        include('ERROR: "one_minute_ping ' +
                                         @args + '" was called with no arguments')
      expect(out).to include('Usage: "one_minute_ping ' +
                                 @args + ' [website]"')
    end

    it '#help plain' do
      out = execute("exe/one_minute_ping help ")
      expect(out).to \
        include('Commands:')
      expect(out).to include('one_minute_ping ' + @args + ' [website]   # website name like https://www.gitlab.com')
      expect(out).to include('one_minute_ping help [COMMAND]  # Describe available commands or one specific command')
    end

    it '#for should work with https://www.gitlab.com/' do
      out = execute('exe/one_minute_ping ' \
                        "#{@args} https://www.gitlab.com/")
      expect(out).to \
        include('Server Hostname:      https://www.gitlab.com/')
      expect(out).to include('Time taken for tests:')
      expect(out).to include('Time per request:')
    end

    it '#for should work with https://www.about.gitlab.com/' do
      out = execute('exe/one_minute_ping ' \
                        "#{@args} https://www.about.gitlab.com/")
      expect(out).to \
        include('Server Hostname:      https://www.about.gitlab.com/')
      expect(out).to include('Time taken for tests:')
      expect(out).to include('Time per request:')
    end

  end
end
