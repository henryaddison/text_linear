module TextLinear
  class Dictionary
    attr_reader :words, :filepath

    def initialize fp
      @words = {}
      @filepath = fp
    end

    def << word, index = nil
      words[word] = index unless words.has_key?(word)
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

    class << self
      def load fp
        (new fp).tap do |obj|
          index = 0
          File.foreach(fp) do |line|
            obj.<<(line.chomp, index)
            index += 1
          end
        end
      end
    end
  end
end