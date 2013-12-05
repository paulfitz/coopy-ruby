module Coopy
  class ViewedDatum 
    
    def initialize(datum,view)
      @datum = datum
      @view = view
    end
    
    attr_accessor :datum
    attr_accessor :view
    
    def to_s 
      return @view.to_s(@datum)
    end
    
    def get_bag 
      return @view.get_bag(@datum)
    end
    
    def get_table 
      return @view.get_table(@datum)
    end
    
    def has_structure 
      return @view.has_structure(@datum)
    end
    
    def ViewedDatum.get_simple_view(datum)
      return ::Coopy::ViewedDatum.new(datum,::Coopy::SimpleView.new)
    end
    
  end
end