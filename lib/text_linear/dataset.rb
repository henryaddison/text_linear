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
      s = samples(dictionary)
      RubyLinear::Problem.new(labels, s, bias, dictionary.size)
    end

    def build_model(dictionary, bias)
      problem = to_problem(dictionary, bias)
      RubyLinear::Model.new(problem, :solver => RubyLinear::L2R_L1LOSS_SVC_DUAL)
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