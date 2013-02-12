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

  context 'problem' do
    before(:each) do
      subject.add('label1', {'cotton' => 1, 'mix' => 1})
      subject.add('label2', {'silk' => 1})
      subject.add('label1', {'cotton' => 1, 'blend' => 1})
      dictionary.save
    end

    describe '#labels' do
      it 'should list the labels in order' do
        subject.labels.should == ['label1', 'label2', 'label1']
      end
    end

    describe '#samples' do
      it 'should list the translated samples' do
        subject.samples.should == [
          {4 => 1, 5 => 1},
          {6 => 1},
          {4 => 1, 7 => 1}
        ]
      end
    end

  end
end