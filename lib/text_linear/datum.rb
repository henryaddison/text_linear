module TextLinear
  class Datum
    attr_reader :label, :features

    def initialize label, features
      @label = label.to_i
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

    class << self
      def from_string label, string, weight
        features = build_features string, weight
        new label, features
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
end