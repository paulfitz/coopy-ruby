module Rb
  class RubyIterator 
    def initialize(x,base)
      @ref = x
      @at = 0
      @base = base
    end
    
    attr_accessor :base
    protected :base
    
    attr_accessor :ref
    protected :ref
    
    attr_accessor :at
    protected :at
    
    def has_next()
      return @at < @ref.length
    end
    
    def _next()
      if(@base == nil) 
        v = @ref[@at]
        @at+=1
        return v
      end
      v = @base[@ref[@at]]
      @at+=1
      return v
    end
    
  end
end