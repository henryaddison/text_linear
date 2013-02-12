require 'spec_helper'

describe TextLinear::Dataset do
  let(:dictionary) { load_dictionary('spec.dictionary') }
  subject { TextLinear::Dataset.new dictionary }
  describe '#new' do
    it 'should have an empty data' do
      subject.data.should be_empty
    end

    it 'should have a dictionary' do
      subject.dictionary.should == dictionary
    end
  end

  describe '#add' do
    let(:features) { {'for' => 1, 'specs' => 1, 'items' => 1} }
    let(:label) { "label" }

    it 'should add a datum to data' do
      expect { subject.add(label, features) }.to change(subject.data, :size).by(1)
      d = subject.data.last
      d.features.should == features
      d.label.should == label
    end

    it 'should add the words to the dictionary' do
      expect { subject.add(label, features) }.to change(dictionary.words, :size).by(1)
      features.keys.each do |word|
        dictionary.words.should have_key(word)
      end
      dictionary.words['item'].should be_nil
    end
  end
end