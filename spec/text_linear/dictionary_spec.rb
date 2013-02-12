require 'spec_helper'

describe TextLinear::Dictionary do
  let(:filepath) { File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dictionaries', 'text.dictionary') }
  before(:all) do
    FileUtils.mkdir_p File.dirname(filepath)
  end
  
  subject { TextLinear::Dictionary.new filepath}

  describe "#new" do
    it "has an empty bag of words" do
      subject.words.should == {}
    end

    it 'should have a filepath' do
      subject.filepath.should == filepath
    end
  end

  describe "#<<" do
    it 'adds a word' do
      subject << "word"
      subject.words.should have_key("word")
    end
  end

  describe "#save" do
    before(:each) do
      subject << "word1"
      subject << "word2"
      subject.save
    end

    it 'assigns integers to words' do
      subject.words["word1"].should == 0
      subject.words["word2"].should == 1
    end

    it 'writes a file' do
      File.read(filepath).should == "word1\nword2\n"
    end
  end
end