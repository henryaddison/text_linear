module TextLinear
  class Datum
    attr_reader :features

    def initialize features
      @features = features
    end

    def translated_features(dictionary)
      @features.inject({}) do |translated, (feature, weight)|
        if translation = dictionary[feature]
          translated[translation] = weight
        end
        translated
      end
    end

    def predict(model, dictionary)
      model.predict(translated_features(dictionary))
    end

    class << self
      def from_string string, weight
        features = build_features string, weight
        new features
      end

      def build_features(string, weight)
        {}.tap do |fhash|
          TextLinear::StringTokeniser.tokenise(string).each do |word|
            fhash[word] = weight
          end
        end
      end
    end
  end

  class Example < Datum
    attr_reader :label

    def initialize features, label
      super features
      @label = label.to_i
    end

    class << self
      def from_string string, weight, label
        features = build_features string, weight
        new features, label
      end
    end
  end
end