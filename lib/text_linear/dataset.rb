require 'ruby_linear'

module TextLinear
  class Dataset
    attr_reader :data

    def initialize
      @data = []
    end

    def add(datum)
      @data << datum
    end

    def labels
      data.collect(&:label)
    end

    def samples(dictionary)
      data.collect { |d| d.translated_features(dictionary) }
    end

    def to_problem(dictionary, bias)
      RubyLinear::Problem.new(labels, samples(dictionary), bias, dictionary.size)
    end

    def build_dictionary
      dictionary = TextLinear::Dictionary.new
      data.each do |datum|
        datum.features.each_key do |term|
          dictionary << term
        end
      end
      return dictionary
    end
  end
end