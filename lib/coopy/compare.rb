module Coopy
  class Compare 
    
    def initialize
    end
    
    def compare(parent,local,remote,report)
      ws = ::Coopy::Workspace.new
      ws.parent = parent
      ws.local = local
      ws.remote = remote
      ws.report = report
      report.clear
      if parent == nil || local == nil || remote == nil 
        report.changes.push(::Coopy::Change.new("only 3-way comparison allowed right now"))
        return false
      end
      return self.compare_structured(ws) if parent.has_structure || local.has_structure || remote.has_structure
      return self.compare_primitive(ws)
    end
    
    protected
    
    def compare_structured(ws)
      ws.tparent = ws.parent.get_table
      ws.tlocal = ws.local.get_table
      ws.tremote = ws.remote.get_table
      if ws.tparent == nil || ws.tlocal == nil || ws.tremote == nil 
        ws.report.changes.push(::Coopy::Change.new("structured comparisons that include non-tables are not available yet"))
        return false
      end
      return self.compare_table(ws)
    end
    
    def compare_table(ws)
      ws.p2l = ::Coopy::TableComparisonState.new
      ws.p2r = ::Coopy::TableComparisonState.new
      ws.p2l.a = ws.tparent
      ws.p2l.b = ws.tlocal
      ws.p2r.a = ws.tparent
      ws.p2r.b = ws.tremote
      cmp = ::Coopy::CompareTable.new
      cmp.attach(ws.p2l)
      cmp.attach(ws.p2r)
      c = ::Coopy::Change.new
      c.parent = ws.parent
      c.local = ws.local
      c.remote = ws.remote
      if ws.p2l.is_equal && !ws.p2r.is_equal 
        c.mode = ::Coopy::ChangeType.remote_change
      elsif !ws.p2l.is_equal && ws.p2r.is_equal 
        c.mode = ::Coopy::ChangeType.local_change
      elsif !ws.p2l.is_equal && !ws.p2r.is_equal 
        ws.l2r = ::Coopy::TableComparisonState.new
        ws.l2r.a = ws.tlocal
        ws.l2r.b = ws.tremote
        cmp.attach(ws.l2r)
        if ws.l2r.is_equal 
          c.mode = ::Coopy::ChangeType.same_change
        else 
          c.mode = ::Coopy::ChangeType.both_change
        end
      else 
        c.mode = ::Coopy::ChangeType.no_change
      end
      ws.report.changes.push(c) if c.mode != ::Coopy::ChangeType.no_change
      return true
    end
    
    def compare_primitive(ws)
      sparent = ws.parent.to_s
      slocal = ws.local.to_s
      sremote = ws.remote.to_s
      c = ::Coopy::Change.new
      c.parent = ws.parent
      c.local = ws.local
      c.remote = ws.remote
      if sparent == slocal && sparent != sremote 
        c.mode = ::Coopy::ChangeType.remote_change
      elsif sparent == sremote && sparent != slocal 
        c.mode = ::Coopy::ChangeType.local_change
      elsif slocal == sremote && sparent != slocal 
        c.mode = ::Coopy::ChangeType.same_change
      elsif sparent != slocal && sparent != sremote 
        c.mode = ::Coopy::ChangeType.both_change
      else 
        c.mode = ::Coopy::ChangeType.no_change
      end
      ws.report.changes.push(c) if c.mode != ::Coopy::ChangeType.no_change
      return true
    end
    
  end
end