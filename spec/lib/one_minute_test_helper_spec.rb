require 'spec_helper'
require 'http'
require 'sniffer'

# to run specs with what"s remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
# rubocop:disable Metrics/BlockLength
describe OneMinuteTestHelper do
  before(:all) do
    @start =     10_000.0
    @finish =    653.5
    @mean_list = [0.5000589999981457, 0.5029990000002726,
                  0.5008369999995921, 0.5025150000001304,
                  0.49944399999731104, 0.49976299999980256]
  end

  describe '#seconds_diff' do
    it 'returns correct result' do
      expect(OneMinuteTestHelper.seconds_diff(@start, @finish)).to eq(-9.3465)
    end
  end

  describe '#millis_diff' do
    it 'returns correct result' do
      expect(OneMinuteTestHelper.millis_diff(@start, @finish)).to
      eq(-9_346_500.0)
    end
  end

  describe '#check_status' do
    Sniffer.disable!
    let(:mean_list) do
      OneMinuteTestHelper.check_status do
        return 'hello'
      end
    end
    it 'returns hello' do
      expect(mean_list).to eq('hello')
    end
  end

  describe '#wait_time' do
    let(:deduction) { Time.now }

    it 'returns correct result' do
      expect(OneMinuteTestHelper.wait_time(deduction, 400.00)).to be_between(-1, 2)
    end
  end

  describe '#seconds' do
    let(:deduction)   { 60_001.561 }
    it 'returns correct result' do
      expect(OneMinuteTestHelper.seconds(deduction)).to eq(60.002)
    end
  end

  describe '#millis_rounded' do
    let(:deduction) { 0.5009361666658757 }

    it 'returns correct result' do
      expect(OneMinuteTestHelper.millis_rounded(deduction)).to eq(500.936)
    end
  end

  describe '#puts_output' do
    let(:elapsed_time) { 60_018.422 }
    it 'returns correct result' do
      expect(OneMinuteTestHelper.puts_output(elapsed_time,
                                             'website',
                                             @mean_list)).to include('Server Hostname:      website')

      expect(OneMinuteTestHelper.puts_output(elapsed_time,
                                             'website',
                                             @mean_list)).to include('Time taken for tests: 60.018 seconds')
      expect(OneMinuteTestHelper.puts_output(elapsed_time,
                                             'website',
                                             @mean_list)).to include('Time per request:     500.936 [ms] (mean, across all concurrent requests)')
    end
  end

  describe '#calculate_average' do
    it 'returns correct result' do
      expect(OneMinuteTestHelper.calculate_average(@mean_list)).to eq(500.936)
    end
  end
end
# rubocop:enable Metrics/BlockLength
