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
  end
end