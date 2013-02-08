module TextLinear
  class Datum
    attr_reader :label, :features

    def initialize label, features
      @label = label
      @features = features
    end
  end
end