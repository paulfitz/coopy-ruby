module Coopy
  class Viterbi 
    
    def initialize
      @K = @T = 0
      self.reset
      @cost = ::Coopy::SparseSheet.new
      @src = ::Coopy::SparseSheet.new
      @path = ::Coopy::SparseSheet.new
    end
    
    protected
    
    attr_accessor :k
    attr_accessor :t
    attr_accessor :index
    attr_accessor :mode
    attr_accessor :path_valid
    attr_accessor :best_cost
    attr_accessor :cost
    attr_accessor :src
    attr_accessor :path
    
    public
    
    def reset 
      @index = 0
      @mode = 0
      @path_valid = false
      @best_cost = 0
    end
    
    def set_size(states,sequence_length)
      @K = states
      @T = sequence_length
      @cost.resize(@K,@T,0)
      @src.resize(@K,@T,-1)
      @path.resize(1,@T,-1)
    end
    
    def assert_mode(_next)
      @index+=1 if _next == 0 && @mode == 1
      @mode = _next
    end
    
    def add_transition(s0,s1,c)
      resize = false
      if s0 >= @K 
        @K = s0 + 1
        resize = true
      end
      if s1 >= @K 
        @K = s1 + 1
        resize = true
      end
      if resize 
        @cost.non_destructive_resize(@K,@T,0)
        @src.non_destructive_resize(@K,@T,-1)
        @path.non_destructive_resize(1,@T,-1)
      end
      @path_valid = false
      self.assert_mode(1)
      if @index >= @T 
        @T = @index + 1
        @cost.non_destructive_resize(@K,@T,0)
        @src.non_destructive_resize(@K,@T,-1)
        @path.non_destructive_resize(1,@T,-1)
      end
      sourced = false
      if @index > 0 
        c += @cost.get(s0,@index - 1)
        sourced = @src.get(s0,@index - 1) != -1
      else 
        sourced = true
      end
      if sourced 
        if c < @cost.get(s1,@index) || @src.get(s1,@index) == -1 
          @cost.set(s1,@index,c)
          @src.set(s1,@index,s0)
        end
      end
    end
    
    def end_transitions 
      @path_valid = false
      self.assert_mode(0)
    end
    
    def begin_transitions 
      @path_valid = false
      self.assert_mode(1)
    end
    
    def calculate_path 
      return if @path_valid
      self.end_transitions
      best = 0
      bestj = -1
      if @index <= 0 
        @path_valid = true
        return
      end
      begin
        _g1 = 0
        _g = @K
        while(_g1 < _g) 
          j = _g1
          _g1+=1
          if (@cost.get(j,@index - 1) < best || bestj == -1) && @src.get(j,@index - 1) != -1 
            best = @cost.get(j,@index - 1)
            bestj = j
          end
        end
      end
      @best_cost = best
      begin
        _g1 = 0
        _g = @index
        while(_g1 < _g) 
          j = _g1
          _g1+=1
          i = @index - 1 - j
          @path.set(0,i,bestj)
          ::Haxe::Log._trace("Problem in Viterbi",{ file_name: "Viterbi.hx", line_number: 117, class_name: "coopy.Viterbi", method_name: "calculatePath"}) if !(bestj != -1 && (bestj >= 0 && bestj < @K))
          bestj = @src.get(bestj,i)
        end
      end
      @path_valid = true
    end
    
    def to_s 
      self.calculate_path
      txt = ""
      begin
        _g1 = 0
        _g = @index
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          if @path.get(0,i) == -1 
            txt += "*"
          else 
            txt += @path.get(0,i)
          end
          txt += " " if @K >= 10
        end
      end
      txt += " costs " + self.get_cost.to_s
      return txt
    end
    
    def length 
      self.calculate_path if @index > 0
      return @index
    end
    
    def get(i)
      self.calculate_path
      return @path.get(0,i)
    end
    
    def get_cost 
      self.calculate_path
      return @best_cost
    end
    
  end
end