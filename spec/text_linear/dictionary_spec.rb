require 'spec_helper'

describe TextLinear::Dictionary do
  let(:filepath) { File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dictionaries', 'text.dictionary') }
  before(:all) do
    FileUtils.mkdir_p File.dirname(filepath)
  end

  after(:all) do
    FileUtils.rm_rf File.dirname(filepath)
  end
  
  subject { TextLinear::Dictionary.new filepath }

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
      subject.words["word"].should be_nil
    end

    context 'with overriding index arg' do
      it 'adds word and set index' do
        subject.<< "word", 3
        subject.words["word"].should == 3
      end
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

  describe '.load' do
    let(:factory_dictionary_filepath) { File.join(File.dirname(__FILE__), '..', 'support', 'dictionaries', 'spec.dictionary') }
    before(:all) { FileUtils.cp(factory_dictionary_filepath, filepath) }
    subject do
      TextLinear::Dictionary.load filepath
    end

    it 'should load a dictionary from the filepath' do
      subject.words.should == {
        'some' => 0,
        'words' => 1,
        'for' => 2,
        'specs' => 3
      }
    end
  end
end