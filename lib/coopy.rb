require "coopy/version"
require "coopy/csv_table"
require "index"
module Coopy
  def self.compare_tables(l,r)
    ::Coopy::Coopy.compare_tables(l,r)
  end

  class CsvTable
     def get_width
       @width
     end

     def get_height
       @height
     end

     def get_cell_view
      ::Coopy::SimpleView.new
     end
  end
end
