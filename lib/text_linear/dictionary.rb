module TextLinear
  class Dictionary
    attr_reader :words, :filepath

    def initialize fp
      @words = {}
      @filepath = fp
    end

    def << word
      words[word] = nil unless words.has_key?(word)
    end

    def save
      index = 0
      File.open(@filepath, 'w+') do |f|
        words.keys.each do |w|
          f.puts w
          words[w] = index
          index+=1
        end
      end
    end
  end
end