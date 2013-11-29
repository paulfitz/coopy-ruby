module Coopy
  class View 
    def toString(d) puts "Abstract View.toString called" end
    def getBag(d) puts "Abstract View.getBag called" end
    def getTable(d) puts "Abstract View.getTable called" end
    def hasStructure(d) puts "Abstract View.hasStructure called" end
    def equals(d1,d2) puts "Abstract View.equals called" end
    def toDatum(str) puts "Abstract View.toDatum called" end
  end
end