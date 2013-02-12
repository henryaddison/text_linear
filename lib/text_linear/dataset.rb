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
  end
end