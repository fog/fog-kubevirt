require_relative './spec_helper'

require 'fog/kubevirt/compute/utils/unit_converter'

describe Fog::Kubevirt::Utils::UnitConverter do

  described_class = Fog::Kubevirt::Utils::UnitConverter

  describe '.convert' do
    it 'converts correctly units that correspond to powers of 10' do
      assert_equal(described_class.convert('1KB', :b).to_i, 10**3)
      assert_equal(described_class.convert('1MB', :b).to_i, 10**6)
      assert_equal(described_class.convert('1GB', :b).to_i, 10**9)
      assert_equal(described_class.convert('1TB', :b).to_i, 10**12)
      assert_equal(described_class.convert('1PB', :b).to_i, 10**15)
      assert_equal(described_class.convert('1EB', :b).to_i, 10**18)
      assert_equal(described_class.convert('1ZB', :b).to_i, 10**21)
      assert_equal(described_class.convert('1YB', :b).to_i, 10**24)
    end

    it 'converts correctly units that correspond to powers of 2' do
      assert_equal(described_class.convert('1KiB', :b).to_i, 2**10)
      assert_equal(described_class.convert('1MiB', :b).to_i, 2**20)
      assert_equal(described_class.convert('1GiB', :b).to_i, 2**30)
      assert_equal(described_class.convert('1TiB', :b).to_i, 2**40)
      assert_equal(described_class.convert('1PiB', :b).to_i, 2**50)
      assert_equal(described_class.convert('1EiB', :b).to_i, 2**60)
      assert_equal(described_class.convert('1ZiB', :b).to_i, 2**70)
      assert_equal(described_class.convert('1YiB', :b).to_i, 2**80)
    end
  
    it 'converts correclty powers of 10 to powers of 2' do
      assert_equal(described_class.convert('1000KB', :kib).to_i, 976)
      assert_equal(described_class.convert('1000MB', :mib).to_i, 953)
      assert_equal(described_class.convert('1000GB', :gib).to_i, 931)
      assert_equal(described_class.convert('1000TB', :tib).to_i, 909)
      assert_equal(described_class.convert('1000PB', :pib).to_i, 888)
      assert_equal(described_class.convert('1000EB', :eib).to_i, 867)
      assert_equal(described_class.convert('1000ZB', :zib).to_i, 847)
      assert_equal(described_class.convert('1000YB', :yib).to_i, 827)
    end
  
    it 'converts correclty powers of 2 to powers of 10' do
      assert_equal(described_class.convert('1000KiB', :kb).to_i, 1024)
      assert_equal(described_class.convert('1000MiB', :mb).to_i, 1048)
      assert_equal(described_class.convert('1000GiB', :gb).to_i, 1073)
      assert_equal(described_class.convert('1000TiB', :tb).to_i, 1099)
      assert_equal(described_class.convert('1000PiB', :pb).to_i, 1125)
      assert_equal(described_class.convert('1000EiB', :eb).to_i, 1152)
      assert_equal(described_class.convert('1000ZiB', :zb).to_i, 1180)
      assert_equal(described_class.convert('1000YiB', :yb).to_i, 1208)
    end
  
    it 'converts to smaller powers of 10 correclty' do
      assert_equal(described_class.convert('1KB', 'B').to_i, 10**3)
      assert_equal(described_class.convert('1MB', 'KB').to_i, 10**3)
      assert_equal(described_class.convert('1GB', 'MB').to_i, 10**3)
      assert_equal(described_class.convert('1TB', 'GB').to_i, 10**3)
      assert_equal(described_class.convert('1PB', 'TB').to_i, 10**3)
      assert_equal(described_class.convert('1EB', 'PB').to_i, 10**3)
      assert_equal(described_class.convert('1ZB', 'EB').to_i, 10**3)
      assert_equal(described_class.convert('1YB', 'ZB').to_i, 10**3)
    end
  
    it 'converts to smaller powers of 2 correclty' do
      assert_equal(described_class.convert('1KiB', 'B').to_i, 2**10)
      assert_equal(described_class.convert('1MiB', 'KiB').to_i, 2**10)
      assert_equal(described_class.convert('1GiB', 'MiB').to_i, 2**10)
      assert_equal(described_class.convert('1TiB', 'GiB').to_i, 2**10)
      assert_equal(described_class.convert('1PiB', 'TiB').to_i, 2**10)
      assert_equal(described_class.convert('1EiB', 'PiB').to_i, 2**10)
      assert_equal(described_class.convert('1ZiB', 'EiB').to_i, 2**10)
      assert_equal(described_class.convert('1YiB', 'ZiB').to_i, 2**10)
    end
  
    it 'converts to larger powers of 10 correclty' do
      assert_equal(described_class.convert('1000b', 'kb').to_i, 1)
      assert_equal(described_class.convert('1000kb', 'mb').to_i, 1)
      assert_equal(described_class.convert('1000mb', 'gb').to_i, 1)
      assert_equal(described_class.convert('1000gb', 'tb').to_i, 1)
      assert_equal(described_class.convert('1000tb', 'pb').to_i, 1)
      assert_equal(described_class.convert('1000pb', 'eb').to_i, 1)
      assert_equal(described_class.convert('1000eb', 'zb').to_i, 1)
      assert_equal(described_class.convert('1000zb', 'yb').to_i, 1)
    end
  
    it 'converts to larger powers of 2 correclty' do
      assert_equal(described_class.convert('1024b', 'ki').to_i, 1)
      assert_equal(described_class.convert('1024kib', 'mi').to_i, 1)
      assert_equal(described_class.convert('1024mib', 'gi').to_i, 1)
      assert_equal(described_class.convert('1024gib', 'ti').to_i, 1)
      assert_equal(described_class.convert('1024tib', 'pi').to_i, 1)
      assert_equal(described_class.convert('1024pib', 'ei').to_i, 1)
      assert_equal(described_class.convert('1024eib', 'zi').to_i, 1)
      assert_equal(described_class.convert('1024zib', 'yi').to_i, 1)
    end
  
    it 'accepts spaces between the numeric value and the unit suffix' do
      assert_equal(described_class.convert('2 KiB', :b).to_i, 2048)
    end
  
    it 'accepts spaces before the numeric value' do
      assert_equal(described_class.convert(' 2KiB', :b).to_i, 2048)
    end
  
    it 'accepts spaces after the unit suffix' do
      assert_equal(described_class.convert('2KiB ', :b).to_i, 2048)
    end
  
    it 'returns nil if no value is given' do
      assert_nil(described_class.convert(nil, :b))
    end
  end

  describe '.validate' do
    it 'fails to validate' do
      assert_raises ::Fog::Kubevirt::Errors::ValidationError do
        described_class.validate('X')
      end
    end

    it 'validates correctly' do
      data = described_class.validate('2Gi')
      assert_equal(data[:value], '2')
      assert_equal(data[:suffix], 'Gi')
    end
  end
end