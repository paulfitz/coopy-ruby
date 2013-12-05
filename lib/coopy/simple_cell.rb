module Coopy
  class SimpleCell 
    
    def initialize(x)
      @datum = x
    end
    
    protected
    
    attr_accessor :datum
    
    public
    
    def to_s 
      return @datum
    end
    
  end
end