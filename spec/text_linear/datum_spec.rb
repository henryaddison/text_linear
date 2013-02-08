require 'spec_helper'

describe TextLinear::Datum do
  describe '#new' do
    let(:label) { 'label1' }
    let(:features) do
      {}
    end
    subject { TextLinear::Datum.new label, features }

    it 'should make a new object with correct attributes' do
      subject.label.should == label
      subject.features.should == features
    end
  end
end