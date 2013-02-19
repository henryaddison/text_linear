require 'spec_helper'

describe TextLinear::Dataset do
  def setup_dataset(dataset)
    dataset.add(TextLinear::Datum.new(1, {'cotton' => 1, 'mix' => 1}))
    dataset.add(TextLinear::Datum.new(2, {'silk' => 1}))
    dataset.add(TextLinear::Datum.new(1, {'cotton' => 1, 'blend' => 1}))

  end

  def setup_dataset_with_dictionary(dataset)
    dataset.add(TextLinear::Datum.new(1, {'cotton' => 1, 'mix' => 1}))
    dataset.add(TextLinear::Datum.new(2, {'silk' => 1}))
    dataset.add(TextLinear::Datum.new(1, {'cotton' => 1, 'blend' => 1}))
    dictionary = subject.build_dictionary
    dictionary.save File.join(TMP_DICTIONARY_DIR, 'spec.dictionary')
    dictionary
  end

  let(:ds) { TextLinear::Dataset.new }
  subject { ds }
  describe '#new' do
    it 'should have an empty data' do
      subject.data.should be_empty
    end
  end

  describe '#add' do
    let(:features) { {'for' => 1, 'specs' => 1, 'items' => 1} }
    let(:label) { 1 }
    let(:datum) { TextLinear::Datum.new(label, features) }
    it 'should add a datum to data' do
      expect { subject.add(datum) }.to change(subject.data, :size).by(1)
      d = subject.data.last
      d.features.should == features
      d.label.should == label
    end
  end

  context 'RubyLinear problem' do
    before(:each) do
      @dictionary = setup_dataset_with_dictionary(subject)
    end

    describe '#labels' do
      it 'should list the labels in order' do
        subject.labels.should == [1,2,1]
      end
    end

    describe '#samples' do
      it 'should list the translated samples' do
        subject.samples(@dictionary).should == [
          {0 => 1, 1 => 1},
          {2 => 1},
          {0 => 1, 3 => 1}
        ]
      end
    end

    describe '#to_problem' do
      it 'should form a liblinear problem' do
        subject.to_problem(@dictionary, 1.0).class.should == RubyLinear::Problem
      end
    end
  end

  describe '#build_dictionary' do
    before(:each) do
      setup_dataset(ds)
    end

    subject { ds.build_dictionary }

    it 'should build a dictionary from the data in the set' do
      subject.should be_a(TextLinear::Dictionary)
      subject.words.keys.should =~ ['cotton', 'mix', 'silk', 'blend']
    end
  end
end