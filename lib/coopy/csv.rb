module Coopy
  class Csv 
    def initialize()
      @cursor = 0
      @row_ended = false
    end
    
    attr_accessor :cursor
    protected :cursor
    
    attr_accessor :row_ended
    protected :row_ended
    
    attr_accessor :has_structure
    protected :has_structure
    
    def render_table(t)
      result = ""
      w = t.get_width()
      h = t.get_height()
      txt = ""
      v = t.get_cell_view()
      begin
        _g = 0
        while(_g < h) 
          y = _g
          _g+=1
          begin
            _g1 = 0
            while(_g1 < w) 
              x = _g1
              _g1+=1
              txt += "," if(x > 0)
              txt += self.render_cell(v,t.get_cell(x,y))
            end
          end
          txt += "\r\n"
        end
      end
      return txt
    end
    
    def render_cell(v,d)
      return "NULL" if(d == nil)
      return "NULL" if(v.equals(d,nil))
      str = v.to_s(d)
      delim = ","
      need_quote = false
      begin
        _g1 = 0
        _g = str.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          ch = str[i]
          if(ch == "\"" || ch == "'" || ch == delim || ch == "\r" || ch == "\n" || ch == "\t" || ch == " ") 
            need_quote = true
            break
          end
        end
      end
      result = ""
      result += "\"" if(need_quote)
      line_buf = ""
      begin
        _g1 = 0
        _g = str.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          ch = str[i]
          result += "\"" if(ch == "\"")
          if(ch != "\r" && ch != "\n") 
            if(line_buf.length > 0) 
              result += line_buf
              line_buf = ""
            end
            result += ch
          
          else 
            line_buf += ch
          end
        end
      end
      result += "\"" if(need_quote)
      return result
    end
    
    def parse_table(txt)
      @cursor = 0
      @row_ended = false
      @has_structure = true
      result = Array.new()
      row = Array.new()
      while(@cursor < txt.length) 
        cell = self.parse_cell(txt)
        row.push(cell)
        if(@row_ended) 
          result.push(row)
          row = Array.new()
        end
        @cursor+=1
      end
      return result
    end
    
    def parse_cell(txt)
      return nil if(txt == nil)
      @row_ended = false
      first_non_underscore = txt.length
      last_processed = 0
      quoting = false
      quote = 0
      result = ""
      start = @cursor
      begin
        _g1 = @cursor
        _g = txt.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          ch = HxOverrides.cca(txt,i)
          last_processed = i
          first_non_underscore = i if(ch != 95 && i < first_non_underscore)
          if(@has_structure) 
            if(!quoting) 
              break if(ch == 44)
              if(ch == 13 || ch == 10) 
                ch2 = HxOverrides.cca(txt,i + 1)
                if(ch2 != nil) 
                  if(ch2 != ch) 
                    last_processed+=1 if(ch2 == 13 || ch2 == 10)
                  end
                end
                @row_ended = true
                break
              end
              if(ch == 34 || ch == 39) 
                if(i == @cursor) 
                  quoting = true
                  quote = ch
                  result += [ch].pack("U") if(i != start)
                  next
                
                else 
                  quoting = true if(ch == quote)
                end
              end
              result += [ch].pack("U")
              next
            end
            if(ch == quote) 
              quoting = false
              next
            end
          end
          result += [ch].pack("U")
        end
      end
      @cursor = last_processed
      if(quote == 0) 
        return nil if(result == "NULL")
        if(first_non_underscore > start) 
          del = first_non_underscore - start
          return HxOverrides.substr(result,1,nil) if(HxOverrides.substr(result,del,nil) == "NULL")
        end
      end
      return result
    end
    
    def parse_single_cell(txt)
      @cursor = 0
      @row_ended = false
      @has_structure = false
      return self.parse_cell(txt)
    end
    
  end
end