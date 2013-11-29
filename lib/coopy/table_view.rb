module Coopy
  class TableView 
    def initialize()
    end
    
    def to_s(d)
      return "" + Std.string(d)
    end
    
    def get_bag(d)
      return nil
    end
    
    def get_table(d)
      table = ::Coopy::Table(d)
      return table
    end
    
    def has_structure(d)
      return true
    end
    
    def equals(d1,d2)
      ::Haxe::Log._trace("TableView.equals called",{ file_name: "TableView.hx", line_number: 28, class_name: "coopy.TableView", method_name: "equals"})
      return false
    end
    
    def to_datum(str)
      return ::Coopy::SimpleCell.new(str)
    end
    
  end
end