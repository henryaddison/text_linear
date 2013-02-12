module TextLinear
  class Dataset
    attr_reader :data, :dictionary

    def initialize dictionary
      @data = []
      @dictionary = dictionary
    end

    def add(label, features)
      @data << Datum.new(label, features)
      features.each_key do |term|
        @dictionary << term
      end
    end

    def labels
      data.collect(&:label)
    end

    def samples
      data.collect { |d| d.translated_features(dictionary) }
    end
  end
end