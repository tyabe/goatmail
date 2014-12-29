require File.expand_path(File.dirname(__FILE__) + '/helper')

describe Goatmail::DeliveryMethod do

  let(:plain_file)  { Dir["#{test_location}/*/plain.html"].first  }
  let(:meta_file)   { Dir["#{test_location}/*/meta"].first    }
  let(:meta)        { Marshal.load(File.read(meta_file)) }

  it 'raises an exception if no location passed' do
    Goatmail.location = nil
    assert_raises(Goatmail::DeliveryMethod::InvalidOption) { Goatmail::DeliveryMethod.new }
    Goatmail.location = test_location
    Goatmail::DeliveryMethod.new
  end

  describe 'using deliver! method' do
    before do
      Mail.new {
        from    'foo@example.com'
        to      'bar@example.com'
        subject 'Hello'
        body    'World!'
      }.deliver!
    end

    it 'creates plain html document' do
      assert File.exist?(plain_file)
    end
    it 'creates meta data file' do
      assert File.exist?(meta_file)
    end
    it 'saves a Subject into the meta data file' do
      assert meta[:subject], 'Hello'
    end
    it 'saves a To into the meta data file' do
      assert meta[:to], 'foo@example.com'
    end
    it 'saves a From into the meta data file' do
      assert meta[:from], 'bar@example.com'
    end

  end

end
