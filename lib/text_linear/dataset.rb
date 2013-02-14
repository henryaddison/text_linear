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

    def build_dictionary
      dict = TextLinear::Dictionary.new
      data.each do |datum|
        datum.features.each_key do |term|
          dict << term
        end
      end
      return dict
    end
  end
end