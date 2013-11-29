module Coopy
  class Change 
    def initialize(txt = nil)
      if(txt != nil) 
        @mode = ::Coopy::ChangeType.note_change
        @change = txt
      
      else 
        @mode = ::Coopy::ChangeType.no_change
      end
    end
    
    attr_accessor :change
    
    
    attr_accessor :parent
    
    
    attr_accessor :local
    
    
    attr_accessor :remote
    
    
    attr_accessor :mode
    
    
    def to_s()
      begin
        _g = @mode
        case(_g[1])
        when 0
          return "no change"
        when 2
          return "local change: " + Std.string(@remote) + " -> " + Std.string(@local)
        when 1
          return "remote change: " + Std.string(@local) + " -> " + Std.string(@remote)
        when 3
          return "conflicting change: " + Std.string(@parent) + " -> " + Std.string(@local) + " / " + Std.string(@remote)
        when 4
          return "same change: " + Std.string(@parent) + " -> " + Std.string(@local) + " / " + Std.string(@remote)
        when 5
          return @change
        end
      end
    end
    
  end
end