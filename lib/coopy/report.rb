module Coopy
  class Report 
    
    def initialize
      @changes = Array.new
    end
    
    attr_accessor :changes
    
    def to_s 
      return @changes.to_s
    end
    
    def clear 
      @changes = Array.new
    end
    
  end
end