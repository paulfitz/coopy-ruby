module Coopy
  class TableText 
    def initialize(rows)
      @rows = rows
      @view = rows.get_cell_view()
    end
    
    attr_accessor :rows
    protected :rows
    
    attr_accessor :view
    protected :view
    
    def get_cell_text(x,y)
      return @view.to_s(@rows.get_cell(x,y))
    end
    
  end
end