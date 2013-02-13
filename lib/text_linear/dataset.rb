require 'ruby_linear'

module TextLinear
  class Dataset
    attr_reader :data, :dictionary

    def initialize dictionary
      @data = []
      @dictionary = dictionary
    end

    def add(datum)
      @data << datum
      datum.features.each_key do |term|
        @dictionary << term
      end
    end

    def labels
      data.collect(&:label)
    end

    def samples
      data.collect { |d| d.translated_features(dictionary) }
    end

    def to_problem(bias)
      RubyLinear::Problem.new(labels, samples, bias, dictionary.size)
    end
  end
end