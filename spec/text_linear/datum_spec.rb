require 'spec_helper'

describe TextLinear::Datum do
  let(:features) do
    {'for' => 1, 'you' => 1, 'some' => 1, 'words' => 1}
  end
  subject { TextLinear::Datum.new features }

  describe '#new' do
    it 'should make a new object with correct attributes' do
      subject.features.should == features
    end
  end

  describe '#translated_features' do
    let(:dictionary) { load_dictionary('spec.dictionary') }
    it 'should convert a word-based features to numeric ones' do
      subject.translated_features(dictionary).should == {2 => 1, 0 => 1, 1 => 1}
    end
  end

  describe '.from_string' do
    let(:string) { "Some words to tokenize"}
    let(:weight) { 0.5 }
    subject { TextLinear::Datum.from_string string, weight }
    it 'should create a datum with words from string' do
      subject.features.should == {
        'some' => 0.5,
        'words' => 0.5,
        'to' => 0.5,
        'tokenize' => 0.5
      }
    end
  end

  describe '.build_features' do
    it 'should split sentence and create hash with weight' do
      sentence = "how now brown cow"
      TextLinear::Datum.build_features(sentence, 0.75).should == {
        'how' => 0.75,
        'now' => 0.75,
        'brown' => 0.75,
        'cow' => 0.75
      }
    end
  end

  describe '.predict' do
    let(:dataset) do
      ds = TextLinear::Dataset.new 
      ds.add(TextLinear::Example.new({'cotton' => 1, 'mix' => 1}, 1))
      ds.add(TextLinear::Example.new({'silk' => 1}, 2))
      ds.add(TextLinear::Example.new({'cotton' => 1, 'blend' => 1}, 1))
      ds
    end
    
    let(:dictionary) do
      dictionary = dataset.build_dictionary
      dictionary.save File.join(TMP_DICTIONARY_DIR, 'spec.dictionary')
      dictionary
    end

    let(:model) do
      dataset.build_model(dictionary, 1)
    end

    it 'should return a label' do
      d = TextLinear::Datum.new({'cotton' => 1, 'mix' => 1})
      d.predict(model, dictionary).should satisfy { |v| [1,2].include?(v) }
    end
  end
end

describe TextLinear::Example do
  let(:label) { 1 }
  let(:features) do
    {'for' => 1, 'you' => 1, 'some' => 1, 'words' => 1}
  end
  subject { TextLinear::Example.new features, label }
  describe '#new' do
    it 'should make a new object with correct attributes' do
      subject.label.should == label
      subject.features.should == features
    end
  end

  describe '.from_string' do
    let(:string) { "Some words to tokenize"}
    let(:weight) { 0.5 }
    subject { TextLinear::Example.from_string string, weight, label }
    it 'should create a datum with words from string' do
      subject.label.should == 1
      subject.features.should == {
        'some' => 0.5,
        'words' => 0.5,
        'to' => 0.5,
        'tokenize' => 0.5
      }
    end
  end
end