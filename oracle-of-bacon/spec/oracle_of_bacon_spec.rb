require 'oracle_of_bacon'

require 'fakeweb'
require 'debugger'

describe OracleOfBacon do
  before(:all) { FakeWeb.allow_net_connect = false }
  describe 'instance' do
    before(:each) { @orb = OracleOfBacon.new('38b99ce9ec87') }
    describe 'when new' do
      subject { @orb }
      it { is_expected.not_to be_valid }
    end
    describe 'when only From is specified' do
      subject { @orb.from = 'Carrie Fisher' ; @orb }
      it { is_expected.to be_valid }

      describe '#from' do
        subject { super().from }
        it { is_expected.to eq('Carrie Fisher') }
      end

      describe '#to' do
        subject { super().to }
        it { is_expected.to eq('Kevin Bacon') }
      end
    end
    describe 'when only To is specified' do
      subject { @orb.to = 'Ian McKellen' ; @orb }
      it { is_expected.to be_valid }

      describe '#from' do
        subject { super().from }
        it { is_expected.to eq('Kevin Bacon') }
      end

      describe '#to' do
        subject { super().to }
        it { is_expected.to eq('Ian McKellen')}
      end
    end
    describe 'when From and To are both specified' do
      context 'and distinct' do
        subject { @orb.to = 'Ian McKellen' ; @orb.from = 'Carrie Fisher' ; @orb }
        it { is_expected.to be_valid }

        describe '#from' do
          subject { super().from }
          it { is_expected.to eq('Carrie Fisher') }
        end

        describe '#to' do
          subject { super().to }
          it { is_expected.to eq('Ian McKellen')  }
        end
      end
      context 'and the same' do
        subject {  @orb.to = @orb.from = 'Ian McKellen' ; @orb }
        it { is_expected.not_to be_valid }
      end
    end
  end
  describe 'parsing XML response', :pending => true do
    describe 'for unauthorized access/invalid API key' do
      subject { OracleOfBacon::Response.new(File.read 'spec/unauthorized_access.xml') }

      describe '#type' do
        subject { super().type }
        it { is_expected.to eq(:error) }
      end

      describe '#data' do
        subject { super().data }
        it { is_expected.to eq('Unauthorized access') }
      end
    end
    describe 'for a normal match' do
      subject { OracleOfBacon::Response.new(File.read 'spec/graph_example.xml') }

      describe '#type' do
        subject { super().type }
        it { is_expected.to eq(:graph) }
      end

      describe '#data' do
        subject { super().data }
        it { is_expected.to eq(['Carrie Fisher', 'Under the Rainbow (1981)',
                              'Chevy Chase', 'Doogal (2006)', 'Ian McKellen']) }
      end
    end
    describe 'for a normal match (backup)' do
      subject { OracleOfBacon::Response.new(File.read 'spec/graph_example2.xml') }

      describe '#type' do
        subject { super().type }
        it { is_expected.to eq(:graph) }
      end

      describe '#data' do
        subject { super().data }
        it { is_expected.to eq(["Ian McKellen", "Doogal (2006)", "Kevin Smith (I)",
                              "Fanboys (2009)", "Carrie Fisher"]) }
      end
    end
    describe 'for a spellcheck match' do
      subject { OracleOfBacon::Response.new(File.read 'spec/spellcheck_example.xml') }

      describe '#type' do
        subject { super().type }
        it { is_expected.to eq(:spellcheck) }
      end

      describe '#data' do
        subject { super().data }

        it 'has 34 elements' do
          expect(subject.size).to eq(34)
        end
      end

      describe '#data' do
        subject { super().data }
        it { is_expected.to include('Anthony Perkins (I)') }
      end

      describe '#data' do
        subject { super().data }
        it { is_expected.to include('Anthony Parkin') }
      end
    end
    describe 'for unknown response' do
      subject { OracleOfBacon::Response.new(File.read 'spec/unknown.xml') }

      describe '#type' do
        subject { super().type }
        it { is_expected.to eq(:unknown) }
      end

      describe '#data' do
        subject { super().data }
        it { is_expected.to match /unknown/i }
      end
    end
  end
  describe 'constructing URI', :pending => true do
    subject do
      oob = OracleOfBacon.new('fake_key')
      oob.from = '3%2 "a' ; oob.to = 'George Clooney'
      oob.make_uri_from_arguments
      oob.uri
    end
    it { is_expected.to match(URI::regexp) }
    it { is_expected.to match /p=fake_key/ }
    it { is_expected.to match /b=George\+Clooney/ }
    it { is_expected.to match /a=3%252\+%22a/ }
  end
  describe 'service connection', :pending => true do
    before(:each) do
      @oob = OracleOfBacon.new
      allow(@oob).to receive(:valid?).and_return(true)
    end
    it 'should create XML if valid response' do
      body = File.read 'spec/graph_example.xml'
      FakeWeb.register_uri(:get, %r(http://oracleofbacon\.org), :body => body)
      expect(OracleOfBacon::Response).to receive(:new).with(body)
      @oob.find_connections
    end
    it 'should raise OracleOfBacon::NetworkError if network problem' do
      FakeWeb.register_uri(:get, %r(http://oracleofbacon\.org),
        :exception => Timeout::Error)
      expect { @oob.find_connections }.
        to raise_error(OracleOfBacon::NetworkError)
    end
  end

end
