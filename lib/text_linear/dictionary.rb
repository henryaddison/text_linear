module TextLinear
  class Dictionary
    class DirtyRead < RuntimeError; end
    attr_reader :words, :filepath
    attr_writer :filepath
    def initialize
      @words = {}
      @dirty = false
    end

    def << word, index = nil
      unless words.has_key?(word)
        words[word] = index
        @dirty = true
      end
    end

    def [] word
      raise DirtyRead, "trying to read from a dictionary which has not been saved." if dirty?
      words[word]
    end

    def dirty?
      @dirty
    end

    def size
      words.size
    end

    def save fp=nil
      self.filepath = fp if fp
      index = 0
      raise "cannot save - no filepath yet provided" unless filepath
      File.open(filepath, 'w+') do |f|
        words.keys.each do |w|
          f.puts w
          words[w] = index
          index+=1
        end
      end
      @dirty = false
    end

    def reload fp=nil
      self.filepath = fp if fp
      @words = {}
      index = 0
      raise "cannot load - no filepath yet provided" unless filepath
      File.foreach(filepath) do |line|
        self.<<(line.chomp, index)
        index += 1
      end
      @dirty = false
    end

    class << self
      def load fp
        (new).tap do |obj|
          obj.reload fp
        end
      end
    end
  end
end