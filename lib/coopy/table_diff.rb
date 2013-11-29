module Coopy
  class TableDiff 
    def initialize(align,flags)
      @align = align
      @flags = flags
    end
    
    attr_accessor :align
    protected :align
    
    attr_accessor :flags
    protected :flags
    
    attr_accessor :l_prev
    protected :l_prev
    
    attr_accessor :r_prev
    protected :r_prev
    
    def get_separator(t,t2,root)
      sep = root
      w = t.get_width()
      h = t.get_height()
      view = t.get_cell_view()
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
              txt = view.to_s(t.get_cell(x,y))
              next if(txt == nil)
              while((txt.index(sep, nil || 0) || -1) >= 0) 
                sep = "-" + sep
              end
            end
          end
        end
      end
      if(t2 != nil) 
        w = t2.get_width()
        h = t2.get_height()
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
                txt = view.to_s(t2.get_cell(x,y))
                next if(txt == nil)
                while((txt.index(sep, nil || 0) || -1) >= 0) 
                  sep = "-" + sep
                end
              end
            end
          end
        end
      end
      return sep
    end
    
    def quote_for_diff(v,d)
      _nil = "NULL"
      return _nil if(v.equals(d,nil))
      str = v.to_s(d)
      score = 0
      begin
        _g1 = 0
        _g = str.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          break if(HxOverrides.cca(str,score) != 95)
          score+=1
        end
      end
      str = "_" + str if(HxOverrides.substr(str,score,nil) == _nil)
      return str
    end
    
    def is_reordered(m,ct)
      reordered = false
      l = -1
      r = -1
      begin
        _g = 0
        while(_g < ct) 
          i = _g
          _g+=1
          unit = m[i]
          next if(unit == nil)
          if(unit.l >= 0) 
            if(unit.l < l) 
              reordered = true
              break
            end
            l = unit.l
          end
          if(unit.r >= 0) 
            if(unit.r < r) 
              reordered = true
              break
            end
            r = unit.r
          end
        end
      end
      return reordered
    end
    
    def spread_context(units,del,active)
      if(del > 0 && active != nil) 
        mark = -del - 1
        skips = 0
        begin
          _g1 = 0
          _g = units.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            if(active[i] == -3) 
              skips+=1
              next
            end
            if(active[i] == 0 || active[i] == 3) 
              if(i - mark <= del + skips) 
                active[i] = 2
              
              else 
                active[i] = 3 if(i - mark == del + 1 + skips)
              end
            
            else 
              if(active[i] == 1) 
                mark = i
                skips = 0
              end
            end
          end
        end
        mark = units.length + del + 1
        skips = 0
        begin
          _g1 = 0
          _g = units.length
          while(_g1 < _g) 
            j = _g1
            _g1+=1
            i = units.length - 1 - j
            if(active[i] == -3) 
              skips+=1
              next
            end
            if(active[i] == 0 || active[i] == 3) 
              if(mark - i <= del + skips) 
                active[i] = 2
              
              else 
                active[i] = 3 if(mark - i == del + 1 + skips)
              end
            
            else 
              if(active[i] == 1) 
                mark = i
                skips = 0
              end
            end
          end
        end
      end
    end
    
    def report_unit(unit)
      txt = unit.to_s()
      reordered = false
      if(unit.l >= 0) 
        reordered = true if(unit.l < @l_prev)
        @l_prev = unit.l
      end
      if(unit.r >= 0) 
        reordered = true if(unit.r < @r_prev)
        @r_prev = unit.r
      end
      txt = "[" + txt + "]" if(reordered)
      return txt
    end
    
    def hilite(output)
      return false if(!output.is_resizable())
      output.resize(0,0)
      output.clear()
      row_map = {}
      col_map = {}
      order = @align.to_order()
      units = order.get_list()
      has_parent = @align.reference != nil
      a = nil
      b = nil
      p = nil
      ra_header = 0
      rb_header = 0
      is_index_p = {}
      is_index_a = {}
      is_index_b = {}
      if(has_parent) 
        p = @align.get_source()
        a = @align.reference.get_target()
        b = @align.get_target()
        ra_header = @align.reference.meta.get_target_header()
        rb_header = @align.meta.get_target_header()
        if(@align.get_index_columns() != nil) 
          _g = 0
          _g1 = @align.get_index_columns()
          while(_g < _g1.length) 
            p2b = _g1[_g]
            _g+=1
            is_index_p[p2b.l] = true if(p2b.l >= 0)
            is_index_b[p2b.r] = true if(p2b.r >= 0)
          end
        end
        if(@align.reference.get_index_columns() != nil) 
          _g = 0
          _g1 = @align.reference.get_index_columns()
          while(_g < _g1.length) 
            p2a = _g1[_g]
            _g+=1
            is_index_p[p2a.l] = true if(p2a.l >= 0)
            is_index_a[p2a.r] = true if(p2a.r >= 0)
          end
        end
      
      else 
        a = @align.get_source()
        b = @align.get_target()
        p = a
        ra_header = @align.meta.get_source_header()
        rb_header = @align.meta.get_target_header()
        if(@align.get_index_columns() != nil) 
          _g = 0
          _g1 = @align.get_index_columns()
          while(_g < _g1.length) 
            a2b = _g1[_g]
            _g+=1
            is_index_a[a2b.l] = true if(a2b.l >= 0)
            is_index_b[a2b.r] = true if(a2b.r >= 0)
          end
        end
      end
      column_order = @align.meta.to_order()
      column_units = column_order.get_list()
      show_rc_numbers = false
      row_moves = nil
      col_moves = nil
      if(@flags.ordered) 
        row_moves = {}
        moves = ::Coopy::Mover.move_units(units)
        begin
          _g1 = 0
          _g = moves.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            begin
              row_moves[moves[i]] = i
              i
            end
          end
        end
        col_moves = {}
        moves = ::Coopy::Mover.move_units(column_units)
        begin
          _g1 = 0
          _g = moves.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            begin
              col_moves[moves[i]] = i
              i
            end
          end
        end
      end
      active = Array.new()
      active_column = nil
      if(!@flags.show_unchanged) 
        _g1 = 0
        _g = units.length
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          active[i] = 0
        end
      end
      allow_insert = @flags.allow_insert()
      allow_delete = @flags.allow_delete()
      allow_update = @flags.allow_update()
      if(!@flags.show_unchanged_columns) 
        active_column = Array.new()
        begin
          _g1 = 0
          _g = column_units.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            v = 0
            unit = column_units[i]
            v = 1 if(unit.l >= 0 && is_index_a[unit.l])
            v = 1 if(unit.r >= 0 && is_index_b[unit.r])
            v = 1 if(unit.p >= 0 && is_index_p[unit.p])
            active_column[i] = v
          end
        end
      end
      outer_reps_needed = nil
      if(@flags.show_unchanged && @flags.show_unchanged_columns) 
        outer_reps_needed = 1
      
      else 
        outer_reps_needed = 2
      end
      v = a.get_cell_view()
      sep = ""
      conflict_sep = ""
      schema = Array.new()
      have_schema = false
      begin
        _g1 = 0
        _g = column_units.length
        while(_g1 < _g) 
          j = _g1
          _g1+=1
          cunit = column_units[j]
          reordered = false
          if(@flags.ordered) 
            reordered = true if(col_moves.include?(j))
            show_rc_numbers = true if(reordered)
          end
          act = ""
          if(cunit.r >= 0 && cunit.lp() == -1) 
            have_schema = true
            act = "+++"
            if(active_column != nil) 
              active_column[j] = 1 if(allow_update)
            end
          end
          if(cunit.r < 0 && cunit.lp() >= 0) 
            have_schema = true
            act = "---"
            if(active_column != nil) 
              active_column[j] = 1 if(allow_update)
            end
          end
          if(cunit.r >= 0 && cunit.lp() >= 0) 
            if(a.get_height() >= ra_header && b.get_height() >= rb_header) 
              aa = a.get_cell(cunit.lp(),ra_header)
              bb = b.get_cell(cunit.r,rb_header)
              if(!v.equals(aa,bb)) 
                have_schema = true
                act = "("
                act += v.to_s(aa)
                act += ")"
                active_column[j] = 1 if(active_column != nil)
              end
            end
          end
          if(reordered) 
            act = ":" + act
            have_schema = true
            active_column = nil if(active_column != nil)
          end
          schema.push(act)
        end
      end
      if(have_schema) 
        at = output.get_height()
        output.resize(column_units.length + 1,at + 1)
        output.set_cell(0,at,v.to_datum("!"))
        begin
          _g1 = 0
          _g = column_units.length
          while(_g1 < _g) 
            j = _g1
            _g1+=1
            output.set_cell(j + 1,at,v.to_datum(schema[j]))
          end
        end
      end
      top_line_done = false
      if(@flags.always_show_header) 
        at = output.get_height()
        output.resize(column_units.length + 1,at + 1)
        output.set_cell(0,at,v.to_datum("@@"))
        begin
          _g1 = 0
          _g = column_units.length
          while(_g1 < _g) 
            j = _g1
            _g1+=1
            cunit = column_units[j]
            if(cunit.r >= 0) 
              output.set_cell(j + 1,at,b.get_cell(cunit.r,rb_header)) if(b.get_height() > 0)
            
            else 
              if(cunit.lp() >= 0) 
                output.set_cell(j + 1,at,a.get_cell(cunit.lp(),ra_header)) if(a.get_height() > 0)
              end
            end
            col_map[j + 1] = cunit
          end
        end
        top_line_done = true
      end
      begin
        _g = 0
        while(_g < outer_reps_needed) 
          out = _g
          _g+=1
          if(out == 1) 
            self.spread_context(units,@flags.unchanged_context,active)
            self.spread_context(column_units,@flags.unchanged_column_context,active_column)
            if(active_column != nil) 
              _g2 = 0
              _g1 = column_units.length
              while(_g2 < _g1) 
                i = _g2
                _g2+=1
                active_column[i] = 0 if(active_column[i] == 3)
              end
            end
          end
          showed_dummy = false
          l = -1
          r = -1
          begin
            _g2 = 0
            _g1 = units.length
            while(_g2 < _g1) 
              i = _g2
              _g2+=1
              unit = units[i]
              reordered = false
              if(@flags.ordered) 
                reordered = true if(row_moves.include?(i))
                show_rc_numbers = true if(reordered)
              end
              next if(unit.r < 0 && unit.l < 0)
              next if(unit.r == 0 && unit.lp() == 0 && top_line_done)
              act = ""
              act = ":" if(reordered)
              publish = @flags.show_unchanged
              dummy = false
              if(out == 1) 
                publish = active[i] > 0
                dummy = active[i] == 3
                next if(dummy && showed_dummy)
                next if(!publish)
              end
              showed_dummy = false if(!dummy)
              at = output.get_height()
              output.resize(column_units.length + 1,at + 1) if(publish)
              if(dummy) 
                begin
                  _g4 = 0
                  _g3 = column_units.length + 1
                  while(_g4 < _g3) 
                    j = _g4
                    _g4+=1
                    output.set_cell(j,at,v.to_datum("..."))
                    showed_dummy = true
                  end
                end
                next
              end
              have_addition = false
              skip = false
              if(unit.p < 0 && unit.l < 0 && unit.r >= 0) 
                skip = true if(!allow_insert)
                act = "+++"
              end
              if((unit.p >= 0 || !has_parent) && unit.l >= 0 && unit.r < 0) 
                skip = true if(!allow_delete)
                act = "---"
              end
              if(skip) 
                if(!publish) 
                  active[i] = -3 if(active != nil)
                end
                next
              end
              begin
                _g4 = 0
                _g3 = column_units.length
                while(_g4 < _g3) 
                  j = _g4
                  _g4+=1
                  cunit = column_units[j]
                  pp = nil
                  ll = nil
                  rr = nil
                  dd = nil
                  dd_to = nil
                  have_dd_to = false
                  dd_to_alt = nil
                  have_dd_to_alt = false
                  have_pp = false
                  have_ll = false
                  have_rr = false
                  if(cunit.p >= 0 && unit.p >= 0) 
                    pp = p.get_cell(cunit.p,unit.p)
                    have_pp = true
                  end
                  if(cunit.l >= 0 && unit.l >= 0) 
                    ll = a.get_cell(cunit.l,unit.l)
                    have_ll = true
                  end
                  if(cunit.r >= 0 && unit.r >= 0) 
                    rr = b.get_cell(cunit.r,unit.r)
                    have_rr = true
                    if((((have_pp) ? cunit.p : cunit.l)) < 0) 
                      if(rr != nil) 
                        if(v.to_s(rr) != "") 
                          have_addition = true if(@flags.allow_update())
                        end
                      end
                    end
                  end
                  if(have_pp) 
                    if(!have_rr) 
                      dd = pp
                    
                    else 
                      if(v.equals(pp,rr)) 
                        dd = pp
                      
                      else 
                        dd = pp
                        dd_to = rr
                        have_dd_to = true
                        if(!v.equals(pp,ll)) 
                          if(!v.equals(pp,rr)) 
                            dd_to_alt = ll
                            have_dd_to_alt = true
                          end
                        end
                      end
                    end
                  
                  else 
                    if(have_ll) 
                      if(!have_rr) 
                        dd = ll
                      
                      else 
                        if(v.equals(ll,rr)) 
                          dd = ll
                        
                        else 
                          dd = ll
                          dd_to = rr
                          have_dd_to = true
                        end
                      end
                    
                    else 
                      dd = rr
                    end
                  end
                  txt = nil
                  if(have_dd_to && allow_update) 
                    active_column[j] = 1 if(active_column != nil)
                    txt = self.quote_for_diff(v,dd)
                    sep = self.get_separator(a,b,"->") if(sep == "")
                    is_conflict = false
                    if(have_dd_to_alt) 
                      is_conflict = true if(!v.equals(dd_to,dd_to_alt))
                    end
                    if(!is_conflict) 
                      txt = txt + sep + self.quote_for_diff(v,dd_to)
                      act = sep if(sep.length > act.length)
                    
                    else 
                      conflict_sep = self.get_separator(p,a,"!") + sep if(conflict_sep == "")
                      txt = txt + conflict_sep + self.quote_for_diff(v,dd_to_alt) + conflict_sep + self.quote_for_diff(v,dd_to)
                      act = conflict_sep
                    end
                  end
                  act = "+" if(act == "" && have_addition)
                  if(act == "+++") 
                    if(have_rr) 
                      active_column[j] = 1 if(active_column != nil)
                    end
                  end
                  if(publish) 
                    if(active_column == nil || active_column[j] > 0) 
                      if(txt != nil) 
                        output.set_cell(j + 1,at,v.to_datum(txt))
                      
                      else 
                        output.set_cell(j + 1,at,dd)
                      end
                    end
                  end
                end
              end
              if(publish) 
                output.set_cell(0,at,v.to_datum(act))
                row_map[at] = unit
              end
              if(act != "") 
                if(!publish) 
                  active[i] = 1 if(active != nil)
                end
              end
            end
          end
        end
      end
      if(!show_rc_numbers) 
        if(@flags.always_show_order) 
          show_rc_numbers = true
        
        else 
          if(@flags.ordered) 
            show_rc_numbers = self.is_reordered(row_map,output.get_height())
            show_rc_numbers = self.is_reordered(col_map,output.get_width()) if(!show_rc_numbers)
          end
        end
      end
      admin_w = 1
      if(show_rc_numbers && !@flags.never_show_order) 
        admin_w+=1
        target = Array.new()
        begin
          _g1 = 0
          _g = output.get_width()
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            target.push(i + 1)
          end
        end
        output.insert_or_delete_columns(target,output.get_width() + 1)
        @l_prev = -1
        @r_prev = -1
        begin
          _g1 = 0
          _g = output.get_height()
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            unit = row_map[i]
            next if(unit == nil)
            output.set_cell(0,i,self.report_unit(unit))
          end
        end
        target = Array.new()
        begin
          _g1 = 0
          _g = output.get_height()
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            target.push(i + 1)
          end
        end
        output.insert_or_delete_rows(target,output.get_height() + 1)
        @l_prev = -1
        @r_prev = -1
        begin
          _g1 = 1
          _g = output.get_width()
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            unit = col_map[i - 1]
            next if(unit == nil)
            output.set_cell(i,0,self.report_unit(unit))
          end
        end
        output.set_cell(0,0,"@:@")
      end
      if(active_column != nil) 
        all_active = true
        begin
          _g1 = 0
          _g = active_column.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            if(active_column[i] == 0) 
              all_active = false
              break
            end
          end
        end
        if(!all_active) 
          fate = Array.new()
          begin
            _g = 0
            while(_g < admin_w) 
              i = _g
              _g+=1
              fate.push(i)
            end
          end
          at = admin_w
          ct = 0
          dots = Array.new()
          begin
            _g1 = 0
            _g = active_column.length
            while(_g1 < _g) 
              i = _g1
              _g1+=1
              off = active_column[i] == 0
              if(off) 
                ct = ct + 1
              
              else 
                ct = 0
              end
              if(off && ct > 1) 
                fate.push(-1)
              
              else 
                dots.push(at) if(off)
                fate.push(at)
                at+=1
              end
            end
          end
          output.insert_or_delete_columns(fate,at)
          begin
            _g = 0
            while(_g < dots.length) 
              d = dots[_g]
              _g+=1
              begin
                _g2 = 0
                _g1 = output.get_height()
                while(_g2 < _g1) 
                  j = _g2
                  _g2+=1
                  output.set_cell(d,j,"...")
                end
              end
            end
          end
        end
      end
      return true
    end
    
  end
end