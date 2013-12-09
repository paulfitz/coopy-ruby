#!/bin/env ruby
# encoding: utf-8

module Coopy
  class Coopy 
    
    def initialize
    end
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    attr_accessor :format_preference
    attr_accessor :io
    attr_accessor :mv
    
    def save_table(name,t)
      txt = ""
      if @format_preference != "json" 
        csv = ::Coopy::Csv.new
        txt = csv.render_table(t)
      else 
        txt = ::Haxe::Json.stringify(::Coopy::Coopy.jsonify(t))
      end
      return self.save_text(name,txt)
    end
    
    def save_text(name,txt)
      if name != "-" 
        @io.save_content(name,txt)
      else 
        @io.write_stdout(txt)
      end
      return true
    end
    
    def load_table(name)
      txt = @io.get_content(name)
      begin
        json = ::Haxe::Json.parse(txt)
        @format_preference = "json"
        t = ::Coopy::Coopy.json_to_table(json)
        throw "JSON failed" if t == nil
        return t
      rescue => e
        csv = ::Coopy::Csv.new
        @format_preference = "csv"
        data = csv.parse_table(txt)
        h = data.length
        w = 0
        w = data[0].length if h > 0
        output = ::Coopy::SimpleTable.new(w,h)
        begin
          _g = 0
          while(_g < h) 
            i = _g
            _g+=1
            begin
              _g1 = 0
              while(_g1 < w) 
                j = _g1
                _g1+=1
                val = data[i][j]
                output.set_cell(j,i,::Coopy::Coopy.cell_for(val))
              end
            end
          end
        end
        output.trim_blank if output != nil
        return output
      end
    end
    
    public
    
    def Coopy.compare_tables(local,remote)
      ct = ::Coopy::CompareTable.new
      comp = ::Coopy::TableComparisonState.new
      comp.a = local
      comp.b = remote
      ct.attach(comp)
      return ct
    end
    
    def Coopy.compare_tables3(parent,local,remote)
      ct = ::Coopy::CompareTable.new
      comp = ::Coopy::TableComparisonState.new
      comp.p = parent
      comp.a = local
      comp.b = remote
      ct.attach(comp)
      return ct
    end
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    def Coopy.random_tests 
      st = ::Coopy::SimpleTable.new(15,6)
      tab = st
      ::Haxe::Log._trace.call("table size is " + tab.get_width.to_s + "x" + tab.get_height.to_s,{ file_name: "Coopy.hx", line_number: 40, class_name: "coopy.Coopy", method_name: "randomTests"})
      tab.set_cell(3,4,::Coopy::SimpleCell.new(33))
      ::Haxe::Log._trace.call("element is " + lambda{ s = tab.get_cell(3,4)
      _r = s.to_s}.call(),{ file_name: "Coopy.hx", line_number: 42, class_name: "coopy.Coopy", method_name: "randomTests"})
      compare = ::Coopy::Compare.new
      d1 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(10))
      d2 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(10))
      d3 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(20))
      report = ::Coopy::Report.new
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 50, class_name: "coopy.Coopy", method_name: "randomTests"})
      d2 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(50))
      report.clear
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 54, class_name: "coopy.Coopy", method_name: "randomTests"})
      d2 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(20))
      report.clear
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 58, class_name: "coopy.Coopy", method_name: "randomTests"})
      d1 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(20))
      report.clear
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 62, class_name: "coopy.Coopy", method_name: "randomTests"})
      tv = ::Coopy::TableView.new
      comp = ::Coopy::TableComparisonState.new
      ct = ::Coopy::CompareTable.new
      comp.a = st
      comp.b = st
      ct.attach(comp)
      ::Haxe::Log._trace.call("comparing tables",{ file_name: "Coopy.hx", line_number: 72, class_name: "coopy.Coopy", method_name: "randomTests"})
      t1 = ::Coopy::SimpleTable.new(3,2)
      t2 = ::Coopy::SimpleTable.new(3,2)
      t3 = ::Coopy::SimpleTable.new(3,2)
      dt1 = ::Coopy::ViewedDatum.new(t1,::Coopy::TableView.new)
      dt2 = ::Coopy::ViewedDatum.new(t2,::Coopy::TableView.new)
      dt3 = ::Coopy::ViewedDatum.new(t3,::Coopy::TableView.new)
      compare.compare(dt1,dt2,dt3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 80, class_name: "coopy.Coopy", method_name: "randomTests"})
      t3.set_cell(1,1,::Coopy::SimpleCell.new("hello"))
      compare.compare(dt1,dt2,dt3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 83, class_name: "coopy.Coopy", method_name: "randomTests"})
      t1.set_cell(1,1,::Coopy::SimpleCell.new("hello"))
      compare.compare(dt1,dt2,dt3,report)
      ::Haxe::Log._trace.call("report is " + report.to_s,{ file_name: "Coopy.hx", line_number: 86, class_name: "coopy.Coopy", method_name: "randomTests"})
      v = ::Coopy::Viterbi.new
      td = ::Coopy::TableDiff.new(nil,nil)
      idx = ::Coopy::Index.new
      dr = ::Coopy::DiffRender.new
      cf = ::Coopy::CompareFlags.new
      hp = ::Coopy::HighlightPatch.new(nil,nil)
      csv = ::Coopy::Csv.new
      tm = ::Coopy::TableModifier.new(nil)
      return 0
    end
    
    def Coopy.cell_for(x)
      return nil if x == nil
      return ::Coopy::SimpleCell.new(x)
    end
    
    def Coopy.json_to_table(json)
      output = nil
      begin
        _g = 0
        _g1 = Reflect.fields(json)
        while(_g < _g1.length) 
          name = _g1[_g]
          _g+=1
          t = json[name]
          columns = t["columns"]
          next if columns == nil
          rows = t["rows"]
          next if rows == nil
          output = ::Coopy::SimpleTable.new(columns.length,rows.length)
          has_hash = false
          has_hash_known = false
          begin
            _g3 = 0
            _g2 = rows.length
            while(_g3 < _g2) 
              i = _g3
              _g3+=1
              row = rows[i]
              if !has_hash_known 
                has_hash = true if Reflect.fields(row).length == columns.length
                has_hash_known = true
              end
              if !has_hash 
                lst = Array(row)
                begin
                  _g5 = 0
                  _g4 = columns.length
                  while(_g5 < _g4) 
                    j = _g5
                    _g5+=1
                    val = lst[j]
                    output.set_cell(j,i,::Coopy::Coopy.cell_for(val))
                  end
                end
              else 
                _g5 = 0
                _g4 = columns.length
                while(_g5 < _g4) 
                  j = _g5
                  _g5+=1
                  val = row[columns[j]]
                  output.set_cell(j,i,::Coopy::Coopy.cell_for(val))
                end
              end
            end
          end
        end
      end
      output.trim_blank if output != nil
      return output
    end
    
    public
    
    def Coopy.coopyhx(io)
      args = io.args
      return ::Coopy::Coopy.random_tests if args[0] == "--test"
      more = true
      output = nil
      css_output = nil
      fragment = false
      pretty = true
      flags = ::Coopy::CompareFlags.new
      flags.always_show_header = true
      while(more) 
        more = false
        begin
          _g1 = 0
          _g = args.length
          while(_g1 < _g) 
            i = _g1
            _g1+=1
            tag = args[i]
            if tag == "--output" 
              more = true
              output = args[i + 1]
              args.slice!(i,2)
              break
            elsif tag == "--css" 
              more = true
              fragment = true
              css_output = args[i + 1]
              args.slice!(i,2)
              break
            elsif tag == "--fragment" 
              more = true
              fragment = true
              args.slice!(i,1)
              break
            elsif tag == "--plain" 
              more = true
              pretty = false
              args.slice!(i,1)
              break
            elsif tag == "--all" 
              more = true
              flags.show_unchanged = true
              args.slice!(i,1)
              break
            elsif tag == "--act" 
              more = true
              flags.acts = {} if flags.acts == nil
              begin
                flags.acts[args[i + 1]] = true
                true
              end
              args.slice!(i,2)
              break
            elsif tag == "--context" 
              more = true
              context = args[i + 1].to_i
              flags.unchanged_context = context if context >= 0
              args.slice!(i,2)
              break
            end
          end
        end
      end
      cmd = args[0]
      if args.length < 2 || !Lambda.has(["diff","patch","trim","render"],cmd) 
        io.write_stderr("The coopyhx utility can produce and apply tabular diffs.\n")
        io.write_stderr("Call coopyhx as:\n")
        io.write_stderr("  coopyhx diff [--output OUTPUT.csv] a.csv b.csv\n")
        io.write_stderr("  coopyhx diff [--output OUTPUT.csv] parent.csv a.csv b.csv\n")
        io.write_stderr("  coopyhx diff [--output OUTPUT.jsonbook] a.jsonbook b.jsonbook\n")
        io.write_stderr("  coopyhx patch [--output OUTPUT.csv] source.csv patch.csv\n")
        io.write_stderr("  coopyhx trim [--output OUTPUT.csv] source.csv\n")
        io.write_stderr("  coopyhx render [--output OUTPUT.html] diff.csv\n")
        io.write_stderr("\n")
        io.write_stderr("If you need more control, here is the full list of flags:\n")
        io.write_stderr("  coopyhx diff [--output OUTPUT.csv] [--context NUM] [--all] [--act ACT] a.csv b.csv\n")
        io.write_stderr("     --context NUM: show NUM rows of context\n")
        io.write_stderr("     --all:         do not prune unchanged rows\n")
        io.write_stderr("     --act ACT:     show only a certain kind of change (update, insert, delete)\n")
        io.write_stderr("\n")
        io.write_stderr("  coopyhx render [--output OUTPUT.html] [--css CSS.css] [--fragment] [--plain] diff.csv\n")
        io.write_stderr("     --css CSS.css: generate a suitable css file to go with the html\n")
        io.write_stderr("     --fragment:    generate just a html fragment rather than a page\n")
        io.write_stderr("     --plain:       do not use fancy utf8 characters to make arrows prettier\n")
        return 1
      end
      output = "-" if output == nil
      cmd1 = args[0]
      tool = ::Coopy::Coopy.new
      tool.io = io
      parent = nil
      offset = 0
      if args.length > 3 
        parent = tool.load_table(args[1])
        offset+=1
      end
      a = tool.load_table(args[1 + offset])
      b = nil
      b = tool.load_table(args[2 + offset]) if args.length > 2
      if cmd1 == "diff" 
        ct = ::Coopy::Coopy.compare_tables3(parent,a,b)
        align = ct.align
        td = ::Coopy::TableDiff.new(align,flags)
        o = ::Coopy::SimpleTable.new(0,0)
        td.hilite(o)
        tool.save_table(output,o)
      elsif cmd1 == "patch" 
        patcher = ::Coopy::HighlightPatch.new(a,b)
        patcher.apply
        tool.save_table(output,a)
      elsif cmd1 == "trim" 
        tool.save_table(output,a)
      elsif cmd1 == "render" 
        renderer = ::Coopy::DiffRender.new
        renderer.use_pretty_arrows(pretty)
        renderer.render(a)
        renderer.complete_html if !fragment
        tool.save_text(output,renderer.html)
        tool.save_text(css_output,renderer.sample_css) if css_output != nil
      end
      return 0
    end
    
    def Coopy.main 
      io = ::Coopy::TableIO.new
      return ::Coopy::Coopy.coopyhx(io)
    end
    
    def Coopy.show(t)
      w = t.get_width
      h = t.get_height
      txt = ""
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
              txt += lambda{ s = t.get_cell(x,y)
              _r = s.to_s}.call()
              txt += " "
            end
          end
          txt += "\n"
        end
      end
      ::Haxe::Log._trace.call(txt,{ file_name: "Coopy.hx", line_number: 345, class_name: "coopy.Coopy", method_name: "show"})
    end
    
    def Coopy.jsonify(t)
      workbook = {}
      sheet = Array.new
      w = t.get_width
      h = t.get_height
      txt = ""
      begin
        _g = 0
        while(_g < h) 
          y = _g
          _g+=1
          row = Array.new
          begin
            _g1 = 0
            while(_g1 < w) 
              x = _g1
              _g1+=1
              v = t.get_cell(x,y)
              if v != nil 
                row.push(v.to_s)
              else 
                row.push(nil)
              end
            end
          end
          sheet.push(row)
        end
      end
      workbook["sheet"] = sheet
      return workbook
    end
    
  end
end