module Sys::Io
  class FileOutput < ::Haxe::Io::Output 
    
    def initialize(f)
      @__f = f
    end
    
    protected
    
    attr_accessor :__f
    
    public
    
     
    
    def write_byte(c)
      @__f.putc(c)
    end
     
    
    def write_bytes(b,p,l)
      s = b.read_string(p,l)
      r = @__f.write(s)
      throw ::Haxe::Io::Error.custom("An error occurred") if r < l
      return r
    end
    
  end
end