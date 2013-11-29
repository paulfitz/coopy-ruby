begin 
  class HxOverrides 
    def HxOverrides.cca(s,index)
      return s[index].ord
    end
    
    def HxOverrides.substr(s,pos,len = nil)
      return "" if(pos != nil && pos != 0 && len != nil && len < 0)
      len = s.length if(len == nil)
      if(pos < 0) 
        pos = s.length + pos
        pos = 0 if(pos < 0)
      
      else 
        len = s.length + len - pos if(len < 0)
      end
      return s[pos,pos+len]
    end
    
    def HxOverrides.iter(a)
      return { cur: 0, arr: a, has_next: lambda {||
        return self.cur < self.arr.length
      }, _next: lambda {||
        return self.arr[self.cur+=1]
      }}
    end
    
  end
end