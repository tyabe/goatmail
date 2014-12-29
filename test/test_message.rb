require File.expand_path(File.dirname(__FILE__) + '/helper')

describe Goatmail::Message do

  before do
    2.times do
      Mail.new {
        from    'foo@example.com'
        to      'bar@example.com'
        subject 'Hello'
        body    'World!'
      }.deliver!
    end
  end

  describe '.location' do
    it 'return Goatmail#location' do
      assert_equal Goatmail::Message.location, Goatmail.location
    end
  end

  describe '.load_all' do
    subject { Goatmail::Message.load_all }
    it 'returns a list of messages' do
      assert_equal subject.count, 2
    end
  end

  describe '.find' do
    let(:id) { '1111111111_1111111' }
    subject { Goatmail::Message.find id }
    it 'returns a message with id set' do
      assert_equal subject.id, id
    end
  end

  describe '.bulk_delete' do
    it 'removes all specified messages' do
      ids = Goatmail::Message.load_all.map(&:id)
      assert_equal ids.count, 2
      Goatmail::Message.bulk_delete(ids)
      assert_equal Goatmail::Message.load_all.count, 0
    end
  end

end
