module Coopy
  class CompareFlags 
    def initialize()
      @ordered = true
      @show_unchanged = false
      @unchanged_context = 1
      @always_show_order = false
      @never_show_order = true
      @show_unchanged_columns = false
      @unchanged_column_context = 1
      @always_show_header = true
      @acts = nil
    end
    
    attr_accessor :ordered
    
    
    attr_accessor :show_unchanged
    
    
    attr_accessor :unchanged_context
    
    
    attr_accessor :always_show_order
    
    
    attr_accessor :never_show_order
    
    
    attr_accessor :show_unchanged_columns
    
    
    attr_accessor :unchanged_column_context
    
    
    attr_accessor :always_show_header
    
    
    attr_accessor :acts
    
    
    def allow_update()
      return true if(@acts == nil)
      return @acts.include?("update")
    end
    
    def allow_insert()
      return true if(@acts == nil)
      return @acts.include?("insert")
    end
    
    def allow_delete()
      return true if(@acts == nil)
      return @acts.include?("delete")
    end
    
  end
end