module Coopy
  class TableText 
    
    def initialize(rows)
      @rows = rows
      @view = rows.get_cell_view
    end
    
    protected
    
    attr_accessor :rows
    attr_accessor :view
    
    public
    
    def get_cell_text(x,y)
      return @view.to_s(@rows.get_cell(x,y))
    end
    
  end
end