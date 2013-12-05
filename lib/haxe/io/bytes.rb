module Haxe::Io
  class Bytes 
    
    def initialize(length,b)
      @length = length
      @b = b
    end
    
    attr_accessor :length
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    attr_accessor :b
    
    public
    
    def read_string(pos,len)
      throw ::Haxe::Io::Error.outside_bounds if pos < 0 || len < 0 || pos + len > @length
      return @b.byteslice(pos,len)
    end
    
    def Bytes.of_string(s)
      return ::Haxe::Io::Bytes.new(s.bytesize,s)
    end
    
  end
end