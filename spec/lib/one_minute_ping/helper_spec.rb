require 'spec_helper'
require 'http'
require 'sniffer'

# to run specs with what"s remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
describe Helper do
  before(:all) do
    @start = 10_000.0
    @finish = 653.5
    @mean_list = [0.5000589999981457, 0.5029990000002726,
                  0.5008369999995921, 0.5025150000001304,
                  0.49944399999731104, 0.49976299999980256]
  end

  describe '#view' do
    it 'returns correct result' do
      printed = capture_stdout do
        Helper.view(Time.at(1_514_761_200.0), 'none.com', @mean_list)
      end
      expect(printed).to include("\nServer Hostname:      none.com\n\n")
      expect(printed).to include('Time taken for tests: ')
      expect(printed).to include('Time per request:     500.936 [ms] ')
      expect(printed).to include("(mean, across all concurrent requests) \n\n")
    end
  end

  describe '#seconds_diff' do
    it 'returns correct result' do
      expect(Helper.seconds_diff(@start, @finish)).to eq(-9.3465)
    end
  end

  describe '#millis_diff' do
    it 'returns correct result' do
      expect(Helper.millis_diff(@start, @finish))
        .to eq(-9_346_500.0)
    end
  end

  describe '#check_status' do
    Sniffer.disable!
    let(:mean_list) do
      Helper.check_status do
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
      expect(Helper.wait_time(deduction,
                              400.00)).to be_between(-1, 2)
    end
  end

  describe '#seconds' do
    let(:deduction) { 60_001.561 }
    it 'returns correct result' do
      expect(Helper.seconds(deduction)).to eq(60.002)
    end
  end

  describe '#millis_rounded' do
    let(:deduction) { 0.5009361666658757 }

    it 'returns correct result' do
      expect(Helper.millis_rounded(deduction)).to eq(500.936)
    end
  end

  describe '#calculate_average' do
    it 'returns correct result' do
      expect(Helper.calculate_average(@mean_list)).to eq(500.936)
    end
  end

  describe '#construct_output' do
    it 'returns correct string' do
      expect(Helper.construct_output(60.027, 'none.com', 500.936))
        .to eq("\nServer Hostname:      none.com\n\n" \
                     "Time taken for tests: 60.027 seconds\n" \
                     'Time per request:     500.936 [ms] ' \
                     "(mean, across all concurrent requests) \n\n")
    end
  end
end
