module Coopy
  class CompareTable 
    
    def initialize
    end
    
    protected
    
    attr_accessor :comp
    attr_accessor :indexes
    
    public
    
    def attach(comp)
      @comp = comp
      more = self.compare_core
      while(more && comp.run_to_completion) 
        more = self.compare_core
      end
      return !more
    end
    
    def align 
      alignment = ::Coopy::Alignment.new
      self.align_core(alignment)
      return alignment
    end
    
    def get_comparison_state 
      return @comp
    end
    
    protected
    
    def align_core(align)
      if @comp.p == nil 
        self.align_core2(align,@comp.a,@comp.b)
        return
      end
      align.reference = ::Coopy::Alignment.new
      self.align_core2(align,@comp.p,@comp.b)
      self.align_core2(align.reference,@comp.p,@comp.a)
      align.meta.reference = align.reference.meta
    end
    
    def align_core2(align,a,b)
      align.meta = ::Coopy::Alignment.new if align.meta == nil
      self.align_columns(align.meta,a,b)
      column_order = align.meta.to_order
      common_units = Array.new
      begin
        _g = 0
        _g1 = column_order.get_list
        while(_g < _g1.length) 
          unit = _g1[_g]
          _g+=1
          common_units.push(unit) if unit.l >= 0 && unit.r >= 0 && unit.p != -1
        end
      end
      align.range(a.get_height,b.get_height)
      align.tables(a,b)
      align.set_rowlike(true)
      w = a.get_width
      ha = a.get_height
      hb = b.get_height
      av = a.get_cell_view
      n = 5
      columns = Array.new
      if common_units.length > n 
        columns_eval = Array.new
        begin
          _g1 = 0
          _g = common_units.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            ct = 0
            mem = {}
            mem2 = {}
            ca = common_units[i].l
            cb = common_units[i].r
            begin
              _g2 = 0
              while(_g2 < ha) 
                j = _g2
                _g2+=1
                key = av.to_s(a.get_cell(ca,j))
                if !mem.include?(key) 
                  mem[key] = 1
                  ct+=1
                end
              end
            end
            begin
              _g2 = 0
              while(_g2 < hb) 
                j = _g2
                _g2+=1
                key = av.to_s(b.get_cell(cb,j))
                if !mem2.include?(key) 
                  mem2[key] = 1
                  ct+=1
                end
              end
            end
            columns_eval.push([i,ct])
          end
        end
        sorter = lambda {|a1,b1|
          return 1 if a1[1] < b1[1]
          return -1 if a1[1] > b1[1]
          return 0
        }
        columns_eval.sort{|a,b| (sorter).call(a,b)}
        columns = Lambda.array(Lambda.map(columns_eval,lambda {|v|
          return v[0]
        }))
        columns = columns.slice(0,n - 1)
      else 
        _g1 = 0
        _g = common_units.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          columns.push(i)
        end
      end
      top = nil
      begin
        v = 2 ** columns.length
        top = v.round
      end
      pending = {}
      begin
        _g = 0
        while(_g < ha) 
          j = _g
          _g+=1
          pending[j] = j
        end
      end
      pending_ct = ha
      begin
        _g = 0
        while(_g < top) 
          k = _g
          _g+=1
          next if k == 0
          break if pending_ct == 0
          active_columns = Array.new
          kk = k
          at = 0
          while(kk > 0) 
            active_columns.push(columns[at]) if kk % 2 == 1
            kk >>= 1
            at+=1
          end
          index = ::Coopy::IndexPair.new
          begin
            _g2 = 0
            _g1 = active_columns.length
            while(_g2 < _g1) 
              k1 = _g2
              _g2+=1
              unit = common_units[active_columns[k1]]
              index.add_columns(unit.l,unit.r)
              align.add_index_columns(unit)
            end
          end
          index.index_tables(a,b)
          h = a.get_height
          h = b.get_height if b.get_height > h
          h = 1 if h < 1
          wide_top_freq = index.get_top_freq
          ratio = wide_top_freq
          ratio /= h + 20
          next if ratio >= 0.1
          @indexes.push(index) if @indexes != nil
          fixed = Array.new
          _it = ::Rb::RubyIterator.new(pending.keys)
          while(_it.has_next) do
            j = _it._next
            cross = index.query_local(j)
            spot_a = cross.spot_a
            spot_b = cross.spot_b
            next if spot_a != 1 || spot_b != 1
            fixed.push(j)
            align.link(j,cross.item_b.lst[0])
          end
          begin
            _g2 = 0
            _g1 = fixed.length
            while(_g2 < _g1) 
              j = _g2
              _g2+=1
              pending.delete(fixed[j])
              pending_ct-=1
            end
          end
        end
      end
      align.link(0,0)
    end
    
    def align_columns(align,a,b)
      align.range(a.get_width,b.get_width)
      align.tables(a,b)
      align.set_rowlike(false)
      slop = 5
      va = a.get_cell_view
      vb = b.get_cell_view
      ra_best = 0
      rb_best = 0
      ct_best = -1
      ma_best = nil
      mb_best = nil
      ra_header = 0
      rb_header = 0
      ra_uniques = 0
      rb_uniques = 0
      begin
        _g = 0
        while(_g < slop) 
          ra = _g
          _g+=1
          break if ra >= a.get_height
          begin
            _g1 = 0
            while(_g1 < slop) 
              rb1 = _g1
              _g1+=1
              break if rb1 >= b.get_height
              ma = {}
              mb = {}
              ct = 0
              uniques = 0
              begin
                _g3 = 0
                _g2 = a.get_width
                while(_g3 < _g2) 
                  ca = _g3
                  _g3+=1
                  key = va.to_s(a.get_cell(ca,ra))
                  if ma.include?(key) 
                    ma[key] = -1
                    uniques-=1
                  else 
                    ma[key] = ca
                    uniques+=1
                  end
                end
              end
              if uniques > ra_uniques 
                ra_header = ra
                ra_uniques = uniques
              end
              uniques = 0
              begin
                _g3 = 0
                _g2 = b.get_width
                while(_g3 < _g2) 
                  cb = _g3
                  _g3+=1
                  key = vb.to_s(b.get_cell(cb,rb1))
                  if mb.include?(key) 
                    mb[key] = -1
                    uniques-=1
                  else 
                    mb[key] = cb
                    uniques+=1
                  end
                end
              end
              if uniques > rb_uniques 
                rb_header = rb1
                rb_uniques = uniques
              end
              _it = ::Rb::RubyIterator.new(ma.keys)
              while(_it.has_next) do
                key = _it._next
                i0 = ma[key]
                i1 = mb[key]
                if i1 != nil 
                  ct+=1 if i1 >= 0 && i0 >= 0
                end
              end
              if ct > ct_best 
                ct_best = ct
                ma_best = ma
                mb_best = mb
                ra_best = ra
                rb_best = rb1
              end
            end
          end
        end
      end
      return if ma_best == nil
      _it2 = ::Rb::RubyIterator.new(ma_best.keys)
      while(_it2.has_next) do
        key = _it2._next
        i0 = ma_best[key]
        i1 = mb_best[key]
        align.link(i0,i1) if i1 >= 0 && i0 >= 0
      end
      align.headers(ra_header,rb_header)
    end
    
    def test_has_same_columns 
      p = @comp.p
      a = @comp.a
      b = @comp.b
      eq = self.has_same_columns2(a,b)
      eq = self.has_same_columns2(p,a) if eq && p != nil
      @comp.has_same_columns = eq
      @comp.has_same_columns_known = true
      return true
    end
    
    def has_same_columns2(a,b)
      return false if a.get_width != b.get_width
      return true if a.get_height == 0 || b.get_height == 0
      av = a.get_cell_view
      begin
        _g1 = 0
        _g = a.get_width
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          begin
            _g3 = i + 1
            _g2 = a.get_width
            while(_g3 < _g2) 
              j = _g3
              _g3+=1
              return false if av.equals(a.get_cell(i,0),a.get_cell(j,0))
            end
          end
          return false if !av.equals(a.get_cell(i,0),b.get_cell(i,0))
        end
      end
      return true
    end
    
    def test_is_equal 
      p = @comp.p
      a = @comp.a
      b = @comp.b
      eq = self.is_equal2(a,b)
      eq = self.is_equal2(p,a) if eq && p != nil
      @comp.is_equal = eq
      @comp.is_equal_known = true
      return true
    end
    
    def is_equal2(a,b)
      return false if a.get_width != b.get_width || a.get_height != b.get_height
      av = a.get_cell_view
      begin
        _g1 = 0
        _g = a.get_height
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          begin
            _g3 = 0
            _g2 = a.get_width
            while(_g3 < _g2) 
              j = _g3
              _g3+=1
              return false if !av.equals(a.get_cell(j,i),b.get_cell(j,i))
            end
          end
        end
      end
      return true
    end
    
    def compare_core 
      return false if @comp.completed
      return self.test_is_equal if !@comp.is_equal_known
      return self.test_has_same_columns if !@comp.has_same_columns_known
      @comp.completed = true
      return false
    end
    
    public
    
    def store_indexes 
      @indexes = Array.new
    end
    
    def get_indexes 
      return @indexes
    end
    
  end
end