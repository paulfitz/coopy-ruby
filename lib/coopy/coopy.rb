module Coopy
  class Coopy 
    def initialize()
    end
    
    attr_accessor :format_preference
    protected :format_preference
    
    attr_accessor :io
    protected :io
    
    attr_accessor :mv
    protected :mv
    
    def Coopy.compare_tables(local,remote)
      ct = ::Coopy::CompareTable.new()
      comp = ::Coopy::TableComparisonState.new()
      comp.a = local
      comp.b = remote
      ct.attach(comp)
      return ct
    end
    
    def Coopy.compare_tables3(parent,local,remote)
      ct = ::Coopy::CompareTable.new()
      comp = ::Coopy::TableComparisonState.new()
      comp.p = parent
      comp.a = local
      comp.b = remote
      ct.attach(comp)
      return ct
    end
    
    def Coopy.random_tests()
      st = ::Coopy::SimpleTable.new(15,6)
      tab = st
      ::Haxe::Log._trace("table size is " + tab.get_width().to_s + "x" + tab.get_height().to_s,{ file_name: "Coopy.hx", line_number: 40, class_name: "coopy.Coopy", method_name: "randomTests"})
      tab.set_cell(3,4,::Coopy::SimpleCell.new(33))
      ::Haxe::Log._trace("element is " + Std.string(tab.get_cell(3,4)),{ file_name: "Coopy.hx", line_number: 42, class_name: "coopy.Coopy", method_name: "randomTests"})
      compare = ::Coopy::Compare.new()
      d1 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(10))
      d2 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(10))
      d3 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(20))
      report = ::Coopy::Report.new()
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 50, class_name: "coopy.Coopy", method_name: "randomTests"})
      d2 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(50))
      report.clear()
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 54, class_name: "coopy.Coopy", method_name: "randomTests"})
      d2 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(20))
      report.clear()
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 58, class_name: "coopy.Coopy", method_name: "randomTests"})
      d1 = ::Coopy::ViewedDatum.get_simple_view(::Coopy::SimpleCell.new(20))
      report.clear()
      compare.compare(d1,d2,d3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 62, class_name: "coopy.Coopy", method_name: "randomTests"})
      tv = ::Coopy::TableView.new()
      comp = ::Coopy::TableComparisonState.new()
      ct = ::Coopy::CompareTable.new()
      comp.a = st
      comp.b = st
      ct.attach(comp)
      ::Haxe::Log._trace("comparing tables",{ file_name: "Coopy.hx", line_number: 72, class_name: "coopy.Coopy", method_name: "randomTests"})
      t1 = ::Coopy::SimpleTable.new(3,2)
      t2 = ::Coopy::SimpleTable.new(3,2)
      t3 = ::Coopy::SimpleTable.new(3,2)
      dt1 = ::Coopy::ViewedDatum.new(t1,::Coopy::TableView.new())
      dt2 = ::Coopy::ViewedDatum.new(t2,::Coopy::TableView.new())
      dt3 = ::Coopy::ViewedDatum.new(t3,::Coopy::TableView.new())
      compare.compare(dt1,dt2,dt3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 80, class_name: "coopy.Coopy", method_name: "randomTests"})
      t3.set_cell(1,1,::Coopy::SimpleCell.new("hello"))
      compare.compare(dt1,dt2,dt3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 83, class_name: "coopy.Coopy", method_name: "randomTests"})
      t1.set_cell(1,1,::Coopy::SimpleCell.new("hello"))
      compare.compare(dt1,dt2,dt3,report)
      ::Haxe::Log._trace("report is " + Std.string(report),{ file_name: "Coopy.hx", line_number: 86, class_name: "coopy.Coopy", method_name: "randomTests"})
      v = ::Coopy::Viterbi.new()
      td = ::Coopy::TableDiff.new(nil,nil)
      idx = ::Coopy::Index.new()
      dr = ::Coopy::DiffRender.new()
      cf = ::Coopy::CompareFlags.new()
      hp = ::Coopy::HighlightPatch.new(nil,nil)
      csv = ::Coopy::Csv.new()
      tm = ::Coopy::TableModifier.new(nil)
      return 0
    end
    
    def Coopy.main()
      return 0
    end
    
    def Coopy.show(t)
      w = t.get_width()
      h = t.get_height()
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
              txt += Std.string(t.get_cell(x,y))
              txt += " "
            end
          end
          txt += "\n"
        end
      end
      ::Haxe::Log._trace(txt,{ file_name: "Coopy.hx", line_number: 345, class_name: "coopy.Coopy", method_name: "show"})
    end
    
    def Coopy.jsonify(t)
      workbook = {}
      sheet = Array.new()
      w = t.get_width()
      h = t.get_height()
      txt = ""
      begin
        _g = 0
        while(_g < h) 
          y = _g
          _g+=1
          row = Array.new()
          begin
            _g1 = 0
            while(_g1 < w) 
              x = _g1
              _g1+=1
              v = t.get_cell(x,y)
              if(v != nil) 
                row.push(v.to_s())
              
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