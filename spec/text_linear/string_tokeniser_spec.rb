require 'spec_helper'

describe TextLinear::StringTokeniser do
  let(:tokeniser) { TextLinear::StringTokeniser }
  describe '.tokenise' do
    it 'should split a sentence into words' do
      sentence = "how now brown cow"
      tokeniser.tokenise(sentence).should == %w{how now brown cow}
    end

    it 'should make all words lower case' do
      sentence = "How nOw browN COW"
      tokeniser.tokenise(sentence).should == %w{how now brown cow}
    end

    it 'should deal with puntuation' do
      sentence = "How now, brown cow."
      tokeniser.tokenise(sentence).should == %w{how now brown cow}
    end
  end
end