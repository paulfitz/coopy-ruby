module Coopy
  class SimpleCell 
    def initialize(x)
      @datum = x
    end
    
    attr_accessor :datum
    protected :datum
    
    def to_s()
      return @datum
    end
    
  end
end