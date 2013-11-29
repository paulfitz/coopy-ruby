module Coopy
  class HighlightPatchUnit 
    def initialize()
      @add = false
      @rem = false
      @update = false
      @sourceRow = -1
      @sourceRowOffset = 0
      @sourcePrevRow = -1
      @sourceNextRow = -1
      @destRow = -1
      @patchRow = -1
      @code = ""
    end
    
    attr_accessor :add
    
    
    attr_accessor :rem
    
    
    attr_accessor :update
    
    
    attr_accessor :code
    
    
    attr_accessor :source_row
    
    
    attr_accessor :source_row_offset
    
    
    attr_accessor :source_prev_row
    
    
    attr_accessor :source_next_row
    
    
    attr_accessor :dest_row
    
    
    attr_accessor :patch_row
    
    
    def to_s()
      return @code + " patchRow " + @patchRow.to_s + " sourceRows " + @sourcePrevRow.to_s + "," + @sourceRow.to_s + "," + @sourceNextRow.to_s + " destRow " + @destRow.to_s
    end
    
  end
end