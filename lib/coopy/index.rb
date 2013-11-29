module Coopy
  class Index 
    def initialize()
      @items = {}
      @cols = Array.new()
      @keys = Array.new()
      @top_freq = 0
      @height = 0
    end
    
    attr_accessor :items
    
    
    attr_accessor :keys
    
    
    attr_accessor :top_freq
    
    
    attr_accessor :height
    
    
    attr_accessor :cols
    protected :cols
    
    attr_accessor :v
    protected :v
    
    attr_accessor :indexed_table
    protected :indexed_table
    
    def add_column(i)
      @cols.push(i)
    end
    
    def index_table(t)
      @indexed_table = t
      begin
        _g1 = 0
        _g = t.get_height()
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          key = nil
          if(@keys.length > i) 
            key = @keys[i]
          
          else 
            key = self.to_key(t,i)
            @keys.push(key)
          end
          item = @items[key]
          if(item == nil) 
            item = ::Coopy::IndexItem.new()
            @items[key] = item
          end
          ct = item.add(i)
          @top_freq = ct if(ct > @top_freq)
        end
      end
      @height = t.get_height()
    end
    
    def to_key(t,i)
      wide = ""
      @v = t.get_cell_view() if(@v == nil)
      begin
        _g1 = 0
        _g = @cols.length
        while(_g1 < _g) 
          k = _g1
          _g1+=1
          d = t.get_cell(@cols[k],i)
          txt = @v.to_s(d)
          next if(txt == "" || txt == "null" || txt == "undefined")
          wide += " // " if(k > 0)
          wide += txt
        end
      end
      return wide
    end
    
    def to_key_by_content(row)
      wide = ""
      begin
        _g1 = 0
        _g = @cols.length
        while(_g1 < _g) 
          k = _g1
          _g1+=1
          txt = row.get_row_string(@cols[k])
          next if(txt == "" || txt == "null" || txt == "undefined")
          wide += " // " if(k > 0)
          wide += txt
        end
      end
      return wide
    end
    
    def get_table()
      return @indexed_table
    end
    
  end
end