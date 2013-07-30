require 'spec_helper'
require './lib/calc_data'

describe CalcData do
  let(:calc_data) { described_class.new('validname') }

  describe 'setup' do
    it "accepts and sets a username" do
      calc_data.instance_variable_get(:@name).should == 'validname'
    end
  end

  describe '#get_repos_for_user' do
    subject { calc_data.send(:get_repos_for_user) }

    context 'with a found user' do
      before { GitHubApi.any_instance.should_receive(:repos).and_return([{'language' => 'ruby'}].to_json) }

      it 'returns an array of hashes' do
        subject.should be_an_instance_of(Array)
      end

      it 'returns a response with a language key' do
        subject.first.should have_key('language')
      end
    end

    context 'with a invalid user' do
      before { GitHubApi.any_instance.should_receive(:repos).and_return([].to_json) }

      it 'returns nil' do
        subject.should be_nil
      end
    end
  end

  describe '#sum_languages' do
    subject { calc_data.send(:sum_languages, data) }
    #before { calc_data.should_receive(:get_repos).and_return(data) }

    describe 'skips missing or null language' do
      let(:data) { [{'language' => nil}] }

      it 'should not change the language count' do
        #expect{subject}.to_not change{calc_data.langs}
        subject.should =={}
      end
    end

    describe 'adds when language key present' do
      let(:data) { [{'language' => 'ruby'}] }

      it 'should not change the language count' do
        subject.should == {:ruby => 1}
      end
    end

    describe 'keeps adding when language key present' do
      let(:data) { [{'language' => 'ruby'}, {'language' => 'ruby'}, {'language' => 'ada'}] }

      it 'should not change the language count' do
        #expect{subject}.to change{calc_data.langs}.from({}).to({:ruby => 2, :ada => 1})
        subject.should == {:ruby => 2, :ada => 1}
      end
    end
  end

  describe '#highest_from' do
    subject { calc_data.send(:highest_from, data) }
    let(:data) { {:ruby => 2, :ada => 1} }

    it "should return an array" do
      subject.should be_an_instance_of(Array)
    end

    it "should return the highest" do
      subject.should == [:ruby, 2]
    end
  end

  describe '#favourite_language' do
    subject { calc_data.favourite_language }

    context 'with a valid github account' do
      before do
        calc_data.stub(:get_repos_for_user).and_return({:some => :data})
        calc_data.stub(:sum_languages)
        calc_data.stub(:highest_from).and_return(data)
      end

      let(:data) { [:ruby, 1] }

      it 'returns a nice string' do
        subject.should == "User validname loves ruby the most"
      end
    end

    context 'with a invalid github username' do
      before do
        calc_data.stub(:get_repos_for_user).and_return(nil)
      end

      it 'returns a nice string' do
        subject.should == "User not found"
      end
    end
  end
end
