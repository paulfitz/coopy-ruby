module Coopy
  class Table 
    
    
    def getCell(x,y) puts "Abstract Table.getCell called" end
    def setCell(x,y,c) puts "Abstract Table.setCell called" end
    def getCellView() puts "Abstract Table.getCellView called" end
    def isResizable() puts "Abstract Table.isResizable called" end
    def resize(w,h) puts "Abstract Table.resize called" end
    def clear() puts "Abstract Table.clear called" end
    def insertOrDeleteRows(fate,hfate) puts "Abstract Table.insertOrDeleteRows called" end
    def insertOrDeleteColumns(fate,wfate) puts "Abstract Table.insertOrDeleteColumns called" end
    def trimBlank() puts "Abstract Table.trimBlank called" end
  end
end