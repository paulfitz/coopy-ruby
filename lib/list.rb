begin 
  class List 
    def initialize()
      @length = 0
    end
    
    attr_accessor :h
    protected :h
    
    attr_accessor :q
    protected :q
    
    attr_accessor :length
    
    
    def add(item)
      x = [item]
      if(@h == nil) 
        @h = x
      
      else 
        @q[1] = x
      end
      @q = x
      @length+=1
    end
    
    def iterator()
      return { h: @h, has_next: lambda {||
        return @h != nil
      }, _next: lambda {||
        return nil if(@h == nil)
        x = @h[0]
        @h = @h[1]
        return x
      }}
    end
    
  end
end