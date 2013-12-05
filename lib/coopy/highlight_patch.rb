module Coopy
  class HighlightPatch 
    
    def initialize(source,patch)
      @source = source
      @patch = patch
      @view = patch.get_cell_view
    end
    
    protected
    
    attr_accessor :source
    attr_accessor :patch
    attr_accessor :view
    attr_accessor :csv
    attr_accessor :header
    attr_accessor :header_pre
    attr_accessor :header_post
    attr_accessor :header_rename
    attr_accessor :header_move
    attr_accessor :modifier
    attr_accessor :current_row
    attr_accessor :payload_col
    attr_accessor :payload_top
    attr_accessor :mods
    attr_accessor :cmods
    attr_accessor :row_info
    attr_accessor :cell_info
    attr_accessor :rc_offset
    attr_accessor :indexes
    attr_accessor :source_in_patch_col
    attr_accessor :patch_in_source_col
    attr_accessor :patch_in_source_row
    attr_accessor :last_source_row
    attr_accessor :actions
    attr_accessor :row_permutation
    attr_accessor :row_permutation_rev
    attr_accessor :col_permutation
    attr_accessor :col_permutation_rev
    attr_accessor :have_dropped_columns
    
    public
    
    def reset 
      @header = {}
      @headerPre = {}
      @headerPost = {}
      @headerRename = {}
      @headerMove = nil
      @modifier = {}
      @mods = Array.new
      @cmods = Array.new
      @csv = ::Coopy::Csv.new
      @rcOffset = 0
      @currentRow = -1
      @rowInfo = ::Coopy::CellInfo.new
      @cellInfo = ::Coopy::CellInfo.new
      @sourceInPatchCol = @patchInSourceCol = nil
      @patchInSourceRow = {}
      @indexes = nil
      @lastSourceRow = -1
      @actions = Array.new
      @rowPermutation = nil
      @rowPermutationRev = nil
      @colPermutation = nil
      @colPermutationRev = nil
      @haveDroppedColumns = false
    end
    
    def apply 
      self.reset
      return true if @patch.get_width < 2
      return true if @patch.get_height < 1
      @payloadCol = 1 + @rcOffset
      @payloadTop = @patch.get_width
      corner = @patch.get_cell_view.to_s(@patch.get_cell(0,0))
      if corner == "@:@" 
        @rcOffset = 1
      else 
        @rcOffset = 0
      end
      begin
        _g1 = 0
        _g = @patch.get_height
        while(_g1 < _g) 
          r = _g1
          _g1+=1
          str = @view.to_s(@patch.get_cell(@rcOffset,r))
          @actions.push(((str != nil) ? str : ""))
        end
      end
      begin
        _g1 = 0
        _g = @patch.get_height
        while(_g1 < _g) 
          r = _g1
          _g1+=1
          self.apply_row(r)
        end
      end
      self.finish_rows
      self.finish_columns
      return true
    end
    
    protected
    
    def need_source_columns 
      return if @sourceInPatchCol != nil
      @sourceInPatchCol = {}
      @patchInSourceCol = {}
      av = @source.get_cell_view
      begin
        _g1 = 0
        _g = @source.get_width
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          name = av.to_s(@source.get_cell(i,0))
          at = @headerPre[name]
          next if at == nil
          @sourceInPatchCol[i] = at
          @patchInSourceCol[at] = i
        end
      end
    end
    
    def need_source_index 
      return if @indexes != nil
      state = ::Coopy::TableComparisonState.new
      state.a = @source
      state.b = @source
      comp = ::Coopy::CompareTable.new
      comp.store_indexes
      comp.attach(state)
      comp.align
      @indexes = comp.get_indexes
      self.need_source_columns
    end
    
    def apply_row(r)
      @currentRow = r
      code = @actions[r]
      if r == 0 && @rcOffset > 0 
      elsif code == "@@" 
        self.apply_header
        self.apply_action("@@")
      elsif code == "!" 
        self.apply_meta
      elsif code == "+++" 
        self.apply_action(code)
      elsif code == "---" 
        self.apply_action(code)
      elsif code == "+" || code == ":" 
        self.apply_action(code)
      elsif (code.index("->",nil || 0) || -1) >= 0 
        self.apply_action("->")
      else 
        @lastSourceRow = -1
      end
    end
    
    def get_datum(c)
      return @patch.get_cell(c,@currentRow)
    end
    
    def get_string(c)
      return @view.to_s(self.get_datum(c))
    end
    
    def apply_meta 
      _g1 = @payloadCol
      _g = @payloadTop
      while(_g1 < _g) 
        i = _g1
        _g1+=1
        name = self.get_string(i)
        next if name == ""
        @modifier[i] = name
      end
    end
    
    def apply_header 
      begin
        _g1 = @payloadCol
        _g = @payloadTop
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          name = self.get_string(i)
          if name == "..." 
            @modifier[i] = "..."
            @haveDroppedColumns = true
            next
          end
          mod = @modifier[i]
          move = false
          if mod != nil 
            if mod[0].ord == 58 
              move = true
              mod = mod[1..mod.length]
            end
          end
          @header[i] = name
          if mod != nil 
            if mod[0].ord == 40 
              prev_name = mod[1..mod.length - 2]
              @headerPre[prev_name] = i
              @headerPost[name] = i
              @headerRename[prev_name] = name
              next
            end
          end
          @headerPre[name] = i if mod != "+++"
          @headerPost[name] = i if mod != "---"
          if move 
            @headerMove = {} if @headerMove == nil
            @headerMove[name] = 1
          end
        end
      end
      self.apply_action("+++") if @source.get_height == 0
    end
    
    def look_up(del = 0)
      at = @patchInSourceRow[@currentRow + del]
      return at if at != nil
      result = -1
      @currentRow += del
      if @currentRow >= 0 && @currentRow < @patch.get_height 
        _g = 0
        _g1 = @indexes
        while(_g < _g1.length) 
          idx = _g1[_g]
          _g+=1
          match = idx.query_by_content(self)
          next if match.spot_a != 1
          result = match.item_a.lst[0]
          break
        end
      end
      begin
        @patchInSourceRow[@currentRow] = result
        result
      end
      @currentRow -= del
      return result
    end
    
    def apply_action(code)
      mod = ::Coopy::HighlightPatchUnit.new
      mod.code = code
      mod.add = code == "+++"
      mod.rem = code == "---"
      mod.update = code == "->"
      self.need_source_index
      @lastSourceRow = self.look_up(-1) if @lastSourceRow == -1
      mod.source_prev_row = @lastSourceRow
      next_act = @actions[@currentRow + 1]
      mod.source_next_row = self.look_up(1) if next_act != "+++" && next_act != "..."
      if mod.add 
        mod.source_prev_row = self.look_up(-1) if @actions[@currentRow - 1] != "+++"
        mod.source_row = mod.source_prev_row
        mod.source_row_offset = 1 if mod.source_row != -1
      else 
        mod.source_row = @lastSourceRow = self.look_up
      end
      @lastSourceRow = mod.source_next_row if @actions[@currentRow + 1] == ""
      mod.patch_row = @currentRow
      mod.source_row = 0 if code == "@@"
      @mods.push(mod)
    end
    
    def check_act 
      act = self.get_string(@rcOffset)
      ::Coopy::DiffRender.examine_cell(0,0,act,"",act,"",@rowInfo) if @rowInfo.value != act
    end
    
    def get_pre_string(txt)
      self.check_act
      return txt if !@rowInfo.updated
      ::Coopy::DiffRender.examine_cell(0,0,txt,"",@rowInfo.value,"",@cellInfo)
      return txt if !@cellInfo.updated
      return @cellInfo.lvalue
    end
    
    public
    
    def get_row_string(c)
      at = @sourceInPatchCol[c]
      return "NOT_FOUND" if at == nil
      return self.get_pre_string(self.get_string(at))
    end
    
    protected
    
    def sort_mods(a,b)
      return 1 if b.code == "@@" && a.code != "@@"
      return -1 if a.code == "@@" && b.code != "@@"
      return 1 if a.source_row == -1 && !a.add && b.source_row != -1
      return -1 if a.source_row != -1 && !b.add && b.source_row == -1
      return 1 if a.source_row + a.source_row_offset > b.source_row + b.source_row_offset
      return -1 if a.source_row + a.source_row_offset < b.source_row + b.source_row_offset
      return 1 if a.patch_row > b.patch_row
      return -1 if a.patch_row < b.patch_row
      return 0
    end
    
    def process_mods(rmods,fate,len)
      rmods.sort{|a,b| (self.sort_mods).call(a,b)}
      offset = 0
      last = -1
      target = 0
      begin
        _g = 0
        while(_g < rmods.length) 
          mod = rmods[_g]
          _g+=1
          if last != -1 
            _g2 = last
            _g1 = mod.source_row + mod.source_row_offset
            while(_g2 < _g1) 
              i = _g2
              _g2+=1
              fate.push(i + offset)
              target+=1
              last+=1
            end
          end
          if mod.rem 
            fate.push(-1)
            offset-=1
          elsif mod.add 
            mod.dest_row = target
            target+=1
            offset+=1
          else 
            mod.dest_row = target
          end
          if mod.source_row >= 0 
            last = mod.source_row + mod.source_row_offset
            last+=1 if mod.rem
          else 
            last = -1
          end
        end
      end
      if last != -1 
        _g = last
        while(_g < len) 
          i = _g
          _g+=1
          fate.push(i + offset)
          target+=1
          last+=1
        end
      end
      return len + offset
    end
    
    def compute_ordering(mods,permutation,permutation_rev,dim)
      to_unit = {}
      from_unit = {}
      meta_from_unit = {}
      ct = 0
      begin
        _g = 0
        while(_g < mods.length) 
          mod = mods[_g]
          _g+=1
          next if mod.add || mod.rem
          next if mod.source_row < 0
          if mod.source_prev_row >= 0 
            begin
              v = mod.source_row
              to_unit[mod.source_prev_row] = v
              v
            end
            begin
              v = mod.source_prev_row
              from_unit[mod.source_row] = v
              v
            end
            ct+=1 if mod.source_prev_row + 1 != mod.source_row
          end
          if mod.source_next_row >= 0 
            begin
              v = mod.source_next_row
              to_unit[mod.source_row] = v
              v
            end
            begin
              v = mod.source_row
              from_unit[mod.source_next_row] = v
              v
            end
            ct+=1 if mod.source_row + 1 != mod.source_next_row
          end
        end
      end
      if ct > 0 
        cursor = nil
        logical = nil
        starts = []
        begin
          _g = 0
          while(_g < dim) 
            i = _g
            _g+=1
            u = from_unit[i]
            if u != nil 
              meta_from_unit[u] = i
              i
            else 
              starts.push(i)
            end
          end
        end
        used = {}
        len = 0
        begin
          _g = 0
          while(_g < dim) 
            i = _g
            _g+=1
            if meta_from_unit.include?(logical) 
              cursor = meta_from_unit[logical]
            else 
              cursor = nil
            end
            if cursor == nil 
              v = starts.shift
              cursor = v
              logical = v
            end
            cursor = 0 if cursor == nil
            while(used.include?(cursor)) 
              cursor = (cursor + 1) % dim
            end
            logical = cursor
            permutation_rev.push(cursor)
            begin
              used[cursor] = 1
              1
            end
          end
        end
        begin
          _g1 = 0
          _g = permutation_rev.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            permutation[i] = -1
          end
        end
        begin
          _g1 = 0
          _g = permutation.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            permutation[permutation_rev[i]] = i
          end
        end
      end
    end
    
    def permute_rows 
      @rowPermutation = Array.new
      @rowPermutationRev = Array.new
      self.compute_ordering(@mods,@rowPermutation,@rowPermutationRev,@source.get_height)
    end
    
    def finish_rows 
      fate = Array.new
      self.permute_rows
      if @rowPermutation.length > 0 
        _g = 0
        _g1 = @mods
        while(_g < _g1.length) 
          mod = _g1[_g]
          _g+=1
          mod.source_row = @rowPermutation[mod.source_row] if mod.source_row >= 0
        end
      end
      @source.insert_or_delete_rows(@rowPermutation,@rowPermutation.length) if @rowPermutation.length > 0
      len = self.process_mods(@mods,fate,@source.get_height)
      @source.insert_or_delete_rows(fate,len)
      begin
        _g = 0
        _g1 = @mods
        while(_g < _g1.length) 
          mod = _g1[_g]
          _g+=1
          if !mod.rem 
            if mod.add 
              _it = ::Rb::RubyIterator.new(@headerPost.values)
              while(_it.has_next) do
                c = _it._next
                offset = @patchInSourceCol[c]
                @source.set_cell(offset,mod.dest_row,@patch.get_cell(c,mod.patch_row)) if offset != nil && offset >= 0
              end
            elsif mod.update 
              @currentRow = mod.patch_row
              self.check_act
              next if !@rowInfo.updated
              _it2 = ::Rb::RubyIterator.new(@headerPre.values)
              while(_it2.has_next) do
                c = _it2._next
                txt = @view.to_s(@patch.get_cell(c,mod.patch_row))
                ::Coopy::DiffRender.examine_cell(0,0,txt,"",@rowInfo.value,"",@cellInfo)
                next if !@cellInfo.updated
                next if @cellInfo.conflicted
                d = @view.to_datum(@csv.parse_single_cell(@cellInfo.rvalue))
                @source.set_cell(@patchInSourceCol[c],mod.dest_row,d)
              end
            end
          end
        end
      end
    end
    
    def permute_columns 
      return if @headerMove == nil
      @colPermutation = Array.new
      @colPermutationRev = Array.new
      self.compute_ordering(@cmods,@colPermutation,@colPermutationRev,@source.get_width)
      return if @colPermutation.length == 0
    end
    
    def finish_columns 
      self.need_source_columns
      begin
        _g1 = @payloadCol
        _g = @payloadTop
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          act = @modifier[i]
          hdr = @header[i]
          act = "" if act == nil
          if act == "---" 
            at = @patchInSourceCol[i]
            mod = ::Coopy::HighlightPatchUnit.new
            mod.code = act
            mod.rem = true
            mod.source_row = at
            mod.patch_row = i
            @cmods.push(mod)
          elsif act == "+++" 
            mod = ::Coopy::HighlightPatchUnit.new
            mod.code = act
            mod.add = true
            prev = -1
            cont = false
            mod.source_row = -1
            mod.source_row = @cmods[@cmods.length - 1].source_row if @cmods.length > 0
            mod.source_row_offset = 1 if mod.source_row != -1
            mod.patch_row = i
            @cmods.push(mod)
          elsif act != "..." 
            mod = ::Coopy::HighlightPatchUnit.new
            mod.code = act
            mod.patch_row = i
            mod.source_row = @patchInSourceCol[i]
            @cmods.push(mod)
          end
        end
      end
      at = -1
      rat = -1
      begin
        _g1 = 0
        _g = @cmods.length - 1
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          icode = @cmods[i].code
          at = @cmods[i].source_row if icode != "+++" && icode != "---"
          @cmods[i + 1].source_prev_row = at
          j = @cmods.length - 1 - i
          jcode = @cmods[j].code
          rat = @cmods[j].source_row if jcode != "+++" && jcode != "---"
          @cmods[j - 1].source_next_row = rat
        end
      end
      fate = Array.new
      self.permute_columns
      if @headerMove != nil 
        if @colPermutation.length > 0 
          begin
            _g = 0
            _g1 = @cmods
            while(_g < _g1.length) 
              mod = _g1[_g]
              _g+=1
              mod.source_row = @colPermutation[mod.source_row] if mod.source_row >= 0
            end
          end
          @source.insert_or_delete_columns(@colPermutation,@colPermutation.length)
        end
      end
      len = self.process_mods(@cmods,fate,@source.get_width)
      @source.insert_or_delete_columns(fate,len)
      begin
        _g = 0
        _g1 = @cmods
        while(_g < _g1.length) 
          cmod = _g1[_g]
          _g+=1
          if !cmod.rem 
            if cmod.add 
              begin
                _g2 = 0
                _g3 = @mods
                while(_g2 < _g3.length) 
                  mod = _g3[_g2]
                  _g2+=1
                  if mod.patch_row != -1 && mod.dest_row != -1 
                    d = @patch.get_cell(cmod.patch_row,mod.patch_row)
                    @source.set_cell(cmod.dest_row,mod.dest_row,d)
                  end
                end
              end
              hdr = @header[cmod.patch_row]
              @source.set_cell(cmod.dest_row,0,@view.to_datum(hdr))
            end
          end
        end
      end
      begin
        _g1 = 0
        _g = @source.get_width
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          name = @view.to_s(@source.get_cell(i,0))
          next_name = @headerRename[name]
          next if next_name == nil
          @source.set_cell(i,0,@view.to_datum(next_name))
        end
      end
    end
    
  end
end