module TextLinear
  class Dictionary
    attr_reader :words, :filepath

    def initialize fp
      @words = {}
      @filepath = fp
      @dirty = false
    end

    def << word, index = nil
      unless words.has_key?(word)
        words[word] = index
        @dirty = true
      end
    end

    def [] word
      words[word]
    end

    def dirty?
      @dirty
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
      @dirty = false
    end

    def reload
      @words = {}
      index = 0
      File.foreach(@filepath) do |line|
        self.<<(line.chomp, index)
        index += 1
      end
      @dirty = false
    end

    class << self
      def load fp
        (new fp).tap do |obj|
          obj.reload
        end
      end
    end
  end
end