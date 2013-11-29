module Coopy
  class SimpleTable 
    def initialize(w,h)
      @data = {}
      @w = w
      @h = h
    end
    
    attr_accessor :data
    protected :data
    
    attr_accessor :w
    protected :w
    
    attr_accessor :h
    protected :h
    
    def get_table()
      return self
    end
    
    def height() get_height end
    def height=(__v) @height = __v end
    
    def width() get_width end
    def width=(__v) @width = __v end
    
    def size() get_size end
    def size=(__v) @size = __v end
    
    def get_width()
      return @w
    end
    
    def get_height()
      return @h
    end
    
    def get_size()
      return @h
    end
    
    def get_cell(x,y)
      return @data[x + y * @w]
    end
    
    def set_cell(x,y,c)
      value = c
      begin
        value1 = value
        @data[x + y * @w] = value1
      end
    end
    
    def to_s()
      return ::Coopy::SimpleTable.table_to_string(self)
    end
    
    def get_cell_view()
      return ::Coopy::SimpleView.new()
    end
    
    def is_resizable()
      return true
    end
    
    def resize(w,h)
      @w = w
      @h = h
      return true
    end
    
    def clear()
      @data = {}
    end
    
    def insert_or_delete_rows(fate,hfate)
      data2 = {}
      begin
        _g1 = 0
        _g = fate.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          j = fate[i]
          if(j != -1) 
            _g3 = 0
            _g2 = @w
            while(_g3 < _g2) 
              c = _g3
              _g3+=1
              idx = i * @w + c
              if(@data.include?(idx)) 
                value = @data[idx]
                begin
                  value1 = value
                  data2[j * @w + c] = value1
                end
              end
            end
          end
        end
      end
      @h = hfate
      @data = data2
      return true
    end
    
    def insert_or_delete_columns(fate,wfate)
      data2 = {}
      begin
        _g1 = 0
        _g = fate.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          j = fate[i]
          if(j != -1) 
            _g3 = 0
            _g2 = @h
            while(_g3 < _g2) 
              r = _g3
              _g3+=1
              idx = r * @w + i
              if(@data.include?(idx)) 
                value = @data[idx]
                begin
                  value1 = value
                  data2[r * wfate + j] = value1
                end
              end
            end
          end
        end
      end
      @w = wfate
      @data = data2
      return true
    end
    
    def trim_blank()
      return true if(@h == 0)
      h_test = @h
      h_test = 3 if(h_test >= 3)
      view = self.get_cell_view()
      space = view.to_datum("")
      more = true
      while(more) 
        begin
          _g1 = 0
          _g = self.get_width()
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            c = self.get_cell(i,@h - 1)
            if(!(view.equals(c,space) || c == nil)) 
              more = false
              break
            end
          end
        end
        @h-=1 if(more)
      end
      more = true
      nw = @w
      while(more) 
        break if(@w == 0)
        begin
          _g = 0
          while(_g < h_test) 
            i = _g
            _g+=1
            c = self.get_cell(nw - 1,i)
            if(!(view.equals(c,space) || c == nil)) 
              more = false
              break
            end
          end
        end
        nw-=1 if(more)
      end
      return true if(nw == @w)
      data2 = {}
      begin
        _g = 0
        while(_g < nw) 
          i = _g
          _g+=1
          begin
            _g2 = 0
            _g1 = @h
            while(_g2 < _g1) 
              r = _g2
              _g2+=1
              idx = r * @w + i
              if(@data.include?(idx)) 
                value = @data[idx]
                begin
                  value1 = value
                  data2[r * nw + i] = value1
                end
              end
            end
          end
        end
      end
      @w = nw
      @data = data2
      return true
    end
    
    def SimpleTable.table_to_string(tab)
      x = ""
      begin
        _g1 = 0
        _g = tab.get_height()
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          begin
            _g3 = 0
            _g2 = tab.get_width()
            while(_g3 < _g2) 
              j = _g3
              _g3+=1
              x += " " if(j > 0)
              x += Std.string(tab.get_cell(j,i))
            end
          end
          x += "\n"
        end
      end
      return x
    end
    
  end
end