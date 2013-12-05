module Coopy
  class Change 
    
    def initialize(txt = nil)
      if txt != nil 
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
    
    def to_s 
      begin
        _g = @mode
        case(_g[1])
        when 0
          return "no change"
        when 2
          return "local change: " + @remote.to_s + " -> " + @local.to_s
        when 1
          return "remote change: " + @local.to_s + " -> " + @remote.to_s
        when 3
          return "conflicting change: " + @parent.to_s + " -> " + @local.to_s + " / " + @remote.to_s
        when 4
          return "same change: " + @parent.to_s + " -> " + @local.to_s + " / " + @remote.to_s
        when 5
          return @change
        end
      end
    end
    
  end
end