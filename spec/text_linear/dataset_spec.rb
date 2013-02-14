require 'spec_helper'

describe TextLinear::Dataset do
  let(:dictionary) { load_dictionary('spec.dictionary') }
  let(:ds) { TextLinear::Dataset.new }
  subject { ds }
  describe '#new' do
    it 'should have an empty data' do
      subject.data.should be_empty
    end

    it 'should not have a dictionary' do
      subject.dictionary.should be_nil
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
      subject.add(TextLinear::Datum.new(1, {'cotton' => 1, 'mix' => 1}))
      subject.add(TextLinear::Datum.new(2, {'silk' => 1}))
      subject.add(TextLinear::Datum.new(1, {'cotton' => 1, 'blend' => 1}))
      dictionary.save
    end

    describe '#labels' do
      it 'should list the labels in order' do
        subject.labels.should == [1,2,1]
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

    describe '#to_problem' do
      it 'should form a liblinear problem' do
        subject.to_problem(1.0).class.should == RubyLinear::Problem
      end
    end
  end

  describe '#update_dictionary' do
    before(:each) do
      ds.add(TextLinear::Datum.new(1, {'cotton' => 1, 'mix' => 1}))
      ds.add(TextLinear::Datum.new(2, {'silk' => 1}))
      ds.add(TextLinear::Datum.new(1, {'cotton' => 1, 'blend' => 1}))
    end

    subject { ds.update_dictionary }

    it 'should build a dictionary from the data in the set' do
      subject.should be_a(TextLinear::Dictionary)
      subject.should == ds.dictionary
      subject.words.keys.should =~ ['cotton', 'mix', 'silk', 'blend']
    end
  end
end