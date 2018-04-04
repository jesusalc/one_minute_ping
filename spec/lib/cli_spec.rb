require 'spec_helper'

# to run specs with what"s remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
describe OneMinuteTest::CLI do
  before(:all) do
    @args = 'site'
  end

  describe 'one_minute_test' do
    it 'should work with https://www.gitlab.com/' do
      out = execute('exe/one_minute_test ' \
                        "#{@args} https://www.gitlab.com/")
      expect(out).to \
        include('Server Hostname:      https://www.gitlab.com/')
      expect(out).to include('Time taken for tests:')
      expect(out).to include('Time per request:')
    end

    it 'should work with https://www.about.gitlab.com/' do
      out = execute('exe/one_minute_test ' \
                        "#{@args} https://www.about.gitlab.com/")
      expect(out).to \
        include('Server Hostname:      https://www.about.gitlab.com/')
      expect(out).to include('Time taken for tests:')
      expect(out).to include('Time per request:')
    end
  end
end
