require 'spec_helper'

# to run specs with what"s remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
# rubocop:disable Metrics/BlockLength
describe OneMinutePing::CLI do
  before(:all) do
    @args = 'for'
  end

  describe 'one_minute_ping' do
    it '#for missing [website] shows command tip' do
      stdout, stderr, status = execute('exe/one_minute_ping ' + @args + ' ')
      expect(status).to be_a(Process::Status)
      expect(stdout).to eq('')
      expect(stderr).to include('ERROR:')
      expect(stderr).to include('one_minute_ping ' + @args)
      expect(stderr).to include('was called with no arguments')
      expect(stderr).to include('Usage:')
      expect(stderr).to include('one_minute_ping ' + @args + ' [website]')
    end

    it '#help [plain]' do
      stdout, stderr, status = execute('exe/one_minute_ping help ')
      expect(status).to be_a(Process::Status)
      expect(stderr).to eq('')
      expect(stdout).to include('Commands:')
      expect(stdout).to include('one_minute_ping ' + @args +
                                 ' [website]   # website name ' \
                                 'like https://www.gitlab.com')
      expect(stdout).to include('one_minute_ping help [COMMAND]' \
                                 '  # Describe available commands ' \
                                 'or one specif')
    end

    it '#help for command ' do
      stdout, stderr, status = execute('exe/one_minute_ping help ' + @args)
      expect(status).to be_a(Process::Status)
      expect(stderr).to eq('')
      expect(stdout).to include('Usage:')
      expect(stdout).to include('one_minute_ping ' + @args + ' [website]')
      expect(stdout).to include('website name like https://www.gitlab.com')
    end

    it '#for should work with https://www.gitlab.com/' do
      stdout, stderr, status = execute('exe/one_minute_ping ' \
                        "#{@args} https://www.gitlab.com/")
      expect(status).to be_a(Process::Status)
      expect(stderr).to eq('')
      expect(stdout).to \
        include('Server Hostname:      https://www.gitlab.com/')
      expect(stdout).to include('Time taken for tests:')
      expect(stdout).to include('Time per request:')
    end

    it '#for should work with https://www.about.gitlab.com/' do
      stdout, stderr, status = execute('exe/one_minute_ping ' \
                        "#{@args} https://www.about.gitlab.com/")
      expect(status).to be_a(Process::Status)
      expect(stderr).to eq('')
      expect(stdout).to \
        include('Server Hostname:      https://www.about.gitlab.com/')
      expect(stdout).to include('Time taken for tests:')
      expect(stdout).to include('Time per request:')
    end
  end
end
# rubocop:enable Metrics/BlockLength
