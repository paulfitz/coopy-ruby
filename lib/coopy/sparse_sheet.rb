module Coopy
  class SparseSheet 
    def initialize()
      @h = @w = 0
    end
    
    attr_accessor :h
    protected :h
    
    attr_accessor :w
    protected :w
    
    attr_accessor :row
    protected :row
    
    attr_accessor :zero
    protected :zero
    
    def resize(w,h,zero)
      @row = {}
      self.non_destructive_resize(w,h,zero)
    end
    
    def non_destructive_resize(w,h,zero)
      @w = w
      @h = h
      @zero = zero
    end
    
    def get(x,y)
      cursor = @row[y]
      return @zero if(cursor == nil)
      val = cursor[x]
      return @zero if(val == nil)
      return val
    end
    
    def set(x,y,val)
      cursor = @row[y]
      if(cursor == nil) 
        cursor = {}
        @row[y] = cursor
      end
      cursor[x] = val
    end
    
  end
end