require 'spec_helper'

describe TextLinear::Datum do
  let(:label) { 1 }
  let(:features) do
    {'for' => 1, 'you' => 1, 'some' => 1, 'words' => 1}
  end
  subject { TextLinear::Datum.new label, features }

  describe '#new' do
    it 'should make a new object with correct attributes' do
      subject.label.should == label
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
    subject { TextLinear::Datum.from_string label, string, weight }
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