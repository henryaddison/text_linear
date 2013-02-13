module TextLinear
  module StringTokeniser
    class << self
      def tokenise(string)
        string.gsub(/\W/," ").downcase.split
      end
    end
  end
end