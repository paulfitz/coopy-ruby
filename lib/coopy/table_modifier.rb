module Coopy
  class TableModifier 
    def initialize(t)
      @t = t
    end
    
    attr_accessor :t
    protected :t
    
    def remove_column(at)
      fate = []
      begin
        _g1 = 0
        _g = @t.get_width()
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          if(i < at) 
            fate.push(i)
          
          else 
            if(i > at) 
              fate.push(i - 1)
            
            else 
              fate.push(-1)
            end
          end
        end
      end
      return @t.insert_or_delete_columns(fate,@t.get_width() - 1)
    end
    
  end
end