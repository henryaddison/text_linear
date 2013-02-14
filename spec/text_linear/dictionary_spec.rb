require 'spec_helper'

describe TextLinear::Dictionary do
  let(:tmp_dictionary_dir) { File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dictionaries') }
  let(:filepath) { File.join(tmp_dictionary_dir, 'text.dictionary') }

  before(:all) do
    FileUtils.mkdir_p tmp_dictionary_dir
  end

  after(:all) do
    FileUtils.rm_rf tmp_dictionary_dir
  end
  
  def dictionary
    @dictionary
  end

  before(:each) do
    @dictionary = TextLinear::Dictionary.new
  end

  describe "#new" do
    it "has an empty bag of words" do
      dictionary.words.should == {}
    end

    it 'should not have a filepath' do
      dictionary.filepath.should be_nil
    end

    it 'should not be dirty' do
      dictionary.dirty?.should be_false
    end
  end

  describe "#<<" do
    it 'adds a word' do
      dictionary << "word"
      dictionary.words.should have_key("word")
      dictionary.words["word"].should be_nil
    end

    it 'should dirty the dictionary' do
      expect { dictionary << "word" }.to change(dictionary, :dirty?) 
      dictionary.dirty?.should be_true
    end

    context 'with overriding index arg' do
      it 'adds word and set index' do
        dictionary.<< "word", 3
        dictionary.words["word"].should == 3
      end
    end
  end

  describe "#[]" do
    before(:each) do
      dictionary << "included word"
      dictionary.save filepath
    end

    it 'returns index of word' do
      dictionary["not included word"].should be_nil
      dictionary["included word"].should == 0
    end

    context 'when dictionary is dirty' do
      it 'should throw an error' do
        dictionary << "another word"
        expect { dictionary["anything"] }.to raise_error(TextLinear::Dictionary::DirtyRead)
      end
    end
  end

  describe "#save" do
    before(:each) do
      dictionary << "word1"
      dictionary << "word2"
    end

    context 'without filepath provided' do
      it 'should raise an error' do
        dictionary.save
      end
    end

    shared_examples "saved dictionary" do
      it 'assigns integers to words' do
        dictionary.words["word1"].should == 0
        dictionary.words["word2"].should == 1
      end

      it 'writes a file' do
        File.read(filepath).should == "word1\nword2\n"
      end

      it 'marks the dictionary clean' do
        dictionary.should_not be_dirty
      end
    end

    context 'with earlier supplied filepath' do
      let(:filepath) { File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dictionaries', 'earlier.dictionary') }
      before(:each) do
        dictionary.filepath = filepath
        dictionary.save
      end

      it_should_behave_like "saved dictionary"
    end

    context 'with filepath provided' do
      let(:filepath) { File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dictionaries', 'later.dictionary') }
      before(:each) do
        dictionary.save filepath
      end

      it_should_behave_like "saved dictionary"
    end

    
  end

  context 'load' do
    let(:factory_dictionary_filepath) { File.join(File.dirname(__FILE__), '..', 'support', 'dictionaries', 'spec.dictionary') }
    before(:all) { FileUtils.cp(factory_dictionary_filepath, filepath) }

    shared_examples "loaded dictionary" do
      it 'should load a dictionary from the filepath' do
        subject.words.should == {
          'some' => 0,
          'words' => 1,
          'for' => 2,
          'specs' => 3
        }
      end

      it 'loaded dictionary should not be dirty' do
        subject.should_not be_dirty
      end
    end

    describe 'class method' do
      subject do
        TextLinear::Dictionary.load filepath
      end

      it_should_behave_like "loaded dictionary"
    end

    describe 'instance method' do
      context 'with no filepath provided' do
        it 'should raise an error' do
          @dictionary.reload
        end
      end

      context 'with filepath provided' do
        subject do
          obj = TextLinear::Dictionary.new
          obj.reload filepath
          obj
        end
        it_should_behave_like "loaded dictionary"
      end

      context 'with filepath provided earlier' do
        subject do
          obj = TextLinear::Dictionary.new
          obj.filepath = filepath
          obj.reload
          obj
        end
        it_should_behave_like "loaded dictionary"
      end

    end
  end

  describe '#size' do
    subject { TextLinear::Dictionary.load filepath }
    it 'should return number of words in dictionary' do
      subject.size.should == 4
    end
  end
end