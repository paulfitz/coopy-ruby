module Coopy
  class DiffRender 
    
    def initialize
      @text_to_insert = Array.new
      @open = false
      @pretty_arrows = true
    end
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    attr_accessor :text_to_insert
    attr_accessor :td_open
    attr_accessor :td_close
    attr_accessor :open
    attr_accessor :pretty_arrows
    
    public
    
    def use_pretty_arrows(flag)
      @pretty_arrows = flag
    end
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    def insert(str)
      @text_to_insert.push(str)
    end
    
    def begin_table 
      self.insert("<table>\n")
    end
    
    def begin_row(mode)
      @td_open = "<td"
      @td_close = "</td>"
      row_class = ""
      if mode == "header" 
        @td_open = "<th"
        @td_close = "</th>"
      else 
        row_class = mode
      end
      tr = "<tr>"
      tr = "<tr class=\"" + row_class + "\">" if row_class != ""
      self.insert(tr)
    end
    
    def insert_cell(txt,mode)
      cell_decorate = ""
      cell_decorate = " class=\"" + mode + "\"" if mode != ""
      self.insert(@td_open + cell_decorate + ">")
      self.insert(txt)
      self.insert(@td_close)
    end
    
    def end_row 
      self.insert("</tr>\n")
    end
    
    def end_table 
      self.insert("</table>\n")
    end
    
    public
    
    def html 
      return @text_to_insert.join("")
    end
    
    def to_s 
      return self.html
    end
    
    def render(rows)
      return if rows.get_width == 0 || rows.get_height == 0
      render = self
      render.begin_table
      change_row = -1
      tt = ::Coopy::TableText.new(rows)
      cell = ::Coopy::CellInfo.new
      corner = tt.get_cell_text(0,0)
      off = nil
      if corner == "@:@" 
        off = 1
      else 
        off = 0
      end
      if off > 0 
        return if rows.get_width <= 1 || rows.get_height <= 1
      end
      begin
        _g1 = 0
        _g = rows.get_height
        while(_g1 < _g) 
          row = _g1
          _g1+=1
          open = false
          txt = tt.get_cell_text(off,row)
          txt = "" if txt == nil
          ::Coopy::DiffRender.examine_cell(0,row,txt,"",txt,corner,cell)
          row_mode = cell.category
          change_row = row if row_mode == "spec"
          render.begin_row(row_mode)
          begin
            _g3 = 0
            _g2 = rows.get_width
            while(_g3 < _g2) 
              c = _g3
              _g3+=1
              ::Coopy::DiffRender.examine_cell(c,row,tt.get_cell_text(c,row),((change_row >= 0) ? tt.get_cell_text(c,change_row) : ""),txt,corner,cell)
              render.insert_cell(((@pretty_arrows) ? cell.pretty_value : cell.value),cell.category_given_tr)
            end
          end
          render.end_row
        end
      end
      render.end_table
    end
    
    def sample_css 
      return ".highlighter .add { \n  background-color: #7fff7f;\n}\n\n.highlighter .remove { \n  background-color: #ff7f7f;\n}\n\n.highlighter td.modify { \n  background-color: #7f7fff;\n}\n\n.highlighter td.conflict { \n  background-color: #f00;\n}\n\n.highlighter .spec { \n  background-color: #aaa;\n}\n\n.highlighter .move { \n  background-color: #ffa;\n}\n\n.highlighter .null { \n  color: #888;\n}\n\n.highlighter table { \n  border-collapse:collapse;\n}\n\n.highlighter td, .highlighter th {\n  border: 1px solid #2D4068;\n  padding: 3px 7px 2px;\n}\n\n.highlighter th, .highlighter .header { \n  background-color: #aaf;\n  font-weight: bold;\n  padding-bottom: 4px;\n  padding-top: 5px;\n  text-align:left;\n}\n\n.highlighter tr:first-child td {\n  border-top: 1px solid #2D4068;\n}\n\n.highlighter td:first-child { \n  border-left: 1px solid #2D4068;\n}\n\n.highlighter td {\n  empty-cells: show;\n}\n"
    end
    
    def complete_html 
      @text_to_insert.insert(0,"<html>\n<meta charset='utf-8'>\n<head>\n<style TYPE='text/css'>\n")
      @text_to_insert.insert(1,self.sample_css)
      @text_to_insert.insert(2,"</style>\n</head>\n<body>\n<div class='highlighter'>\n")
      @text_to_insert.push("</div>\n</body>\n</html>\n")
    end
    
    def DiffRender.examine_cell(x,y,value,vcol,vrow,vcorner,cell)
      cell.category = ""
      cell.category_given_tr = ""
      cell.separator = ""
      cell.conflicted = false
      cell.updated = false
      cell.pvalue = cell.lvalue = cell.rvalue = nil
      cell.value = value
      cell.value = "" if cell.value == nil
      cell.pretty_value = cell.value
      vrow = "" if vrow == nil
      vcol = "" if vcol == nil
      removed_column = false
      cell.category = "move" if vrow == ":"
      if (vcol.index("+++",nil || 0) || -1) >= 0 
        cell.category_given_tr = cell.category = "add"
      elsif (vcol.index("---",nil || 0) || -1) >= 0 
        cell.category_given_tr = cell.category = "remove"
        removed_column = true
      end
      if vrow == "!" 
        cell.category = "spec"
      elsif vrow == "@@" 
        cell.category = "header"
      elsif vrow == "+++" 
        cell.category = "add" if !removed_column
      elsif vrow == "---" 
        cell.category = "remove"
      elsif (vrow.index("->",nil || 0) || -1) >= 0 
        if !removed_column 
          tokens = vrow.split("!")
          full = vrow
          part = tokens[1]
          part = full if part == nil
          if (cell.value.index(part,nil || 0) || -1) >= 0 
            cat = "modify"
            div = part
            if part != full 
              if (cell.value.index(full,nil || 0) || -1) >= 0 
                div = full
                cat = "conflict"
                cell.conflicted = true
              end
            end
            cell.updated = true
            cell.separator = div
            if cell.pretty_value == div 
              tokens = ["",""]
            else 
              tokens = cell.pretty_value.split(div)
            end
            pretty_tokens = tokens
            if tokens.length >= 2 
              pretty_tokens[0] = ::Coopy::DiffRender.mark_spaces(tokens[0],tokens[1])
              pretty_tokens[1] = ::Coopy::DiffRender.mark_spaces(tokens[1],tokens[0])
            end
            if tokens.length >= 3 
              ref = pretty_tokens[0]
              pretty_tokens[0] = ::Coopy::DiffRender.mark_spaces(ref,tokens[2])
              pretty_tokens[2] = ::Coopy::DiffRender.mark_spaces(tokens[2],ref)
            end
            cell.pretty_value = pretty_tokens.join([8594].pack("U"))
            cell.category_given_tr = cell.category = cat
            offset = nil
            if cell.conflicted 
              offset = 1
            else 
              offset = 0
            end
            cell.lvalue = tokens[offset]
            cell.rvalue = tokens[offset + 1]
            cell.pvalue = tokens[0] if cell.conflicted
          end
        end
      end
    end
    
    def DiffRender.mark_spaces(sl,sr)
      return sl if sl == sr
      return sl if sl == nil || sr == nil
      slc = sl.gsub(" ","")
      src = sr.gsub(" ","")
      return sl if slc != src
      slo = String.new("")
      il = 0
      ir = 0
      while(il < sl.length) 
        cl = sl[il]
        cr = ""
        cr = sr[ir] if ir < sr.length
        if cl == cr 
          slo += cl
          il+=1
          ir+=1
        elsif cr == " " 
          ir+=1
        else 
          slo += [9251].pack("U")
          il+=1
        end
      end
      return slo
    end
    
    def DiffRender.render_cell(tt,x,y)
      cell = ::Coopy::CellInfo.new
      corner = tt.get_cell_text(0,0)
      off = nil
      if corner == "@:@" 
        off = 1
      else 
        off = 0
      end
      ::Coopy::DiffRender.examine_cell(x,y,tt.get_cell_text(x,y),tt.get_cell_text(x,off),tt.get_cell_text(off,y),corner,cell)
      return cell
    end
    
  end
end