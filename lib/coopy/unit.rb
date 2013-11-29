module Coopy
  class Unit 
    def initialize(l = -2,r = -2,p = -2)
      @l = l
      @r = r
      @p = p
    end
    
    attr_accessor :l
    
    
    attr_accessor :r
    
    
    attr_accessor :p
    
    
    def lp()
      if(@p == -2) 
        return @l
      
      else 
        return @p
      end
    end
    
    def to_s()
      return ::Coopy::Unit.describe(@p) + "|" + ::Coopy::Unit.describe(@l) + ":" + ::Coopy::Unit.describe(@r) if(@p >= -1)
      return ::Coopy::Unit.describe(@l) + ":" + ::Coopy::Unit.describe(@r)
    end
    
    def from_string(txt)
      txt += "]"
      at = 0
      begin
        _g1 = 0
        _g = txt.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          ch = HxOverrides.cca(txt,i)
          if(ch >= 48 && ch <= 57) 
            at *= 10
            at += ch - 48
          
          else 
            if(ch == 45) 
              at = -1
            
            else 
              if(ch == 124) 
                @p = at
                at = 0
              
              else 
                if(ch == 58) 
                  @l = at
                  at = 0
                
                else 
                  if(ch == 93) 
                    @r = at
                    return true
                  end
                end
              end
            end
          end
        end
      end
      return false
    end
    
    def Unit.describe(i)
      if(i >= 0) 
        return "" + i.to_s
      
      else 
        return "-"
      end
    end
    
  end
end