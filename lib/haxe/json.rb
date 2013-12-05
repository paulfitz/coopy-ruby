module Haxe
  class Json 
    
    def initialize
    end
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    attr_accessor :buf
    attr_accessor :str
    attr_accessor :pos
    attr_accessor :replacer
    
    def to_s(v,replacer = nil)
      @buf = StringBuf.new
      @replacer = replacer
      self.to_string_rec("",v)
      return @buf.b
    end
    
    def fields_string(v,fields)
      first = true
      @buf.b += [123].pack("U")
      begin
        _g = 0
        while(_g < fields.length) 
          f = fields[_g]
          _g+=1
          value = nil
          begin
            v1 = nil
            begin
              v1 = v[f.to_sym]
            rescue => e
            end
            value = v1
          end
          next if Reflect.is_function(value)
          if first 
            first = false
          else 
            @buf.b += [44].pack("U")
          end
          self.quote(f)
          @buf.b += [58].pack("U")
          self.to_string_rec(f,value)
        end
      end
      @buf.b += [125].pack("U")
    end
    
    def obj_string(v)
      self.fields_string(v,Reflect.fields(v))
    end
    
    def to_string_rec(k,v)
      v = (@replacer).call(k,v) if @replacer != nil
      begin
        _g = Type._typeof(v)
        case(_g[1])
        when 8
          @buf.b += "\"???\"".to_s
        when 4
          self.obj_string(v)
        when 1
          begin
            v1 = v
            @buf.b += v1.to_s
          end
        when 2
          begin
            v1 = nil
            if lambda{|_this_| f = v
            _r = f.finite?}.call(self) 
              v1 = v
            else 
              v1 = "null"
            end
            @buf.b += v1.to_s
          end
        when 5
          @buf.b += "\"<fun>\"".to_s
        when 6
          begin
            c = _g.params[0]
            if c == String 
              self.quote(v)
            elsif c == Array 
              v1 = v
              @buf.b += [91].pack("U")
              len = v1.length
              if len > 0 
                self.to_string_rec(0,v1[0])
                i = 1
                while(i < len) 
                  @buf.b += [44].pack("U")
                  self.to_string_rec(i,v1[i+=1])
                end
              end
              @buf.b += [93].pack("U")
            elsif c == ::Haxe::Ds::StringMap 
              v1 = v
              o = { }
              _it2 = ::Rb::RubyIterator.new(v1.keys)
              while(_it2.has_next) do
                k1 = _it2._next
                value = v1[k1]
                o[k1] = value
              end
              self.obj_string(o)
            else 
              self.obj_string(v)
            end
          end
        when 7
          begin
            i = nil
            begin
              e = v
              i = e[1]
            end
            begin
              v1 = i
              @buf.b += v1.to_s
            end
          end
        when 3
          begin
            v1 = v
            @buf.b += v1.to_s
          end
        when 0
          @buf.b += "null".to_s
        end
      end
    end
    
    def quote(s)
      @buf.b += [34].pack("U")
      i = 0
      while(true) 
        c = nil
        begin
          index = i
          i+=1
          c = s[index].ord
        end
        break if c == 0
        case(c)
        when 34
          @buf.b += "\\\"".to_s
        when 92
          @buf.b += "\\\\".to_s
        when 10
          @buf.b += "\\n".to_s
        when 13
          @buf.b += "\\r".to_s
        when 9
          @buf.b += "\\t".to_s
        when 8
          @buf.b += "\\b".to_s
        when 12
          @buf.b += "\\f".to_s
        else
          @buf.b += [c].pack("U")
        end
      end
      @buf.b += [34].pack("U")
    end
    
    def do_parse(str)
      @str = str
      @pos = 0
      return self.parse_rec
    end
    
    def invalid_char 
      @pos-=1
      throw "Invalid char " + @str[@pos].ord.to_s + " at position " + @pos.to_s
    end
    
    def parse_rec 
      while(true) 
        c = nil
        begin
          index = @pos
          @pos+=1
          c = @str[index].ord
        end
        case(c)
        when 32
          when 13
          when 10
          when 9
          when 123
          begin
            obj = { }
            field = nil
            comma = nil
            while(true) 
              c1 = nil
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 32
                when 13
                when 10
                when 9
                when 125
                begin
                  self.invalid_char if field != nil || comma == false
                  return obj
                end
              when 58
                begin
                  self.invalid_char if field == nil
                  begin
                    value = self.parse_rec
                    obj[field] = value
                  end
                  field = nil
                  comma = true
                end
              when 44
                if comma 
                  comma = false
                else 
                  self.invalid_char
                end
              when 34
                begin
                  self.invalid_char if comma
                  field = self.parse_string
                end
              else
                self.invalid_char
              end
            end
          end
        when 91
          begin
            arr = []
            comma = nil
            while(true) 
              c1 = nil
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 32
                when 13
                when 10
                when 9
                when 93
                begin
                  self.invalid_char if comma == false
                  return arr
                end
              when 44
                if comma 
                  comma = false
                else 
                  self.invalid_char
                end
              else
                begin
                  self.invalid_char if comma
                  @pos-=1
                  arr.push(self.parse_rec)
                  comma = true
                end
              end
            end
          end
        when 116
          begin
            save = @pos
            if lambda{|_this_| index = @pos
            @pos+=1
            _r = @str[index].ord}.call(self) != 114 || lambda{|_this_| index = @pos
            @pos+=1
            _r2 = @str[index].ord}.call(self) != 117 || lambda{|_this_| index = @pos
            @pos+=1
            _r3 = @str[index].ord}.call(self) != 101 
              @pos = save
              self.invalid_char
            end
            return true
          end
        when 102
          begin
            save = @pos
            if lambda{|_this_| index = @pos
            @pos+=1
            _r4 = @str[index].ord}.call(self) != 97 || lambda{|_this_| index = @pos
            @pos+=1
            _r5 = @str[index].ord}.call(self) != 108 || lambda{|_this_| index = @pos
            @pos+=1
            _r6 = @str[index].ord}.call(self) != 115 || lambda{|_this_| index = @pos
            @pos+=1
            _r7 = @str[index].ord}.call(self) != 101 
              @pos = save
              self.invalid_char
            end
            return false
          end
        when 110
          begin
            save = @pos
            if lambda{|_this_| index = @pos
            @pos+=1
            _r8 = @str[index].ord}.call(self) != 117 || lambda{|_this_| index = @pos
            @pos+=1
            _r9 = @str[index].ord}.call(self) != 108 || lambda{|_this_| index = @pos
            @pos+=1
            _r10 = @str[index].ord}.call(self) != 108 
              @pos = save
              self.invalid_char
            end
            return nil
          end
        when 34
          return self.parse_string
        when 48
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 49
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 50
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 51
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 52
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 53
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 54
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 55
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 56
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 57
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        when 45
          begin
            c1 = c
            start = @pos - 1
            minus = c1 == 45
            digit = !minus
            zero = c1 == 48
            point = false
            e = false
            pm = false
            _end = false
            while(true) 
              begin
                index = @pos
                @pos+=1
                c1 = @str[index].ord
              end
              case(c1)
              when 48
                begin
                  self.invalid_number(start) if zero && !point
                  if minus 
                    minus = false
                    zero = true
                  end
                  digit = true
                end
              when 49
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 50
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 51
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 52
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 53
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 54
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 55
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 56
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 57
                begin
                  self.invalid_number(start) if zero && !point
                  minus = false if minus
                  digit = true
                  zero = false
                end
              when 46
                begin
                  self.invalid_number(start) if minus || point
                  digit = false
                  point = true
                end
              when 101
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 69
                begin
                  self.invalid_number(start) if minus || zero || e
                  digit = false
                  e = true
                end
              when 43
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              when 45
                begin
                  self.invalid_number(start) if !e || pm
                  digit = false
                  pm = true
                end
              else
                begin
                  self.invalid_number(start) if !digit
                  @pos-=1
                  _end = true
                end
              end
              break if _end
            end
            f = nil
            begin
              x = @str[start..@pos - start]
              f = x.to_f
            end
            i = int(f) | 0
            if i == f 
              return i
            else 
              return f
            end
          end
        else
          self.invalid_char
        end
      end
    end
    
    def parse_string 
      start = @pos
      buf = StringBuf.new
      while(true) 
        c = nil
        begin
          index = @pos
          @pos+=1
          c = @str[index].ord
        end
        break if c == 34
        if c == 92 
          begin
            s = @str
            len = @pos - start - 1
            buf.b += ((len == nil) ? s[start..-1] : s[start..len])
          end
          begin
            index = @pos
            @pos+=1
            c = @str[index].ord
          end
          case(c)
          when 114
            buf.b += [13].pack("U")
          when 110
            buf.b += [10].pack("U")
          when 116
            buf.b += [9].pack("U")
          when 98
            buf.b += [8].pack("U")
          when 102
            buf.b += [12].pack("U")
          when 47
            buf.b += [c].pack("U")
          when 92
            buf.b += [c].pack("U")
          when 34
            buf.b += [c].pack("U")
          when 117
            begin
              uc = nil
              begin
                x = "0x" + @str[@pos..4]
                uc = x.to_i
              end
              @pos += 4
              buf.b += [uc].pack("U")
            end
          else
            throw "Invalid escape sequence \\" + [c].pack("U") + " at position " + (@pos - 1).to_s
          end
          start = @pos
        elsif c == 0 
          throw "Unclosed string"
        end
      end
      begin
        s = @str
        len = @pos - start - 1
        buf.b += ((len == nil) ? s[start..-1] : s[start..len])
      end
      return buf.b
    end
    
    def invalid_number(start)
      throw "Invalid number at position " + start.to_s + ": " + @str[start..@pos - start]
    end
    
    public
    
    def Json.parse(text)
      return ::Haxe::Json.new.do_parse(text)
    end
    
    def Json.stringify(value,replacer = nil)
      return ::Haxe::Json.new.to_s(value,replacer)
    end
    
  end
end