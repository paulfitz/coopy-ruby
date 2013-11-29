begin 
  class Lambda 
    def Lambda.array(it)
      a = Array.new()
      _it = it.iterator()
      while( _it.has_next() ) do i = _it._next()
      a.push(i)
      end
      return a
    end
    
    def Lambda.map(it,f)
      l = List.new()
      _it = it.iterator()
      while( _it.has_next() ) do x = _it._next()
      l.add(f(x))
      end
      return l
    end
    
  end
end