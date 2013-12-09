#!/bin/env ruby
# encoding: utf-8

module Coopy
  class SimpleView 
    
    def initialize
    end
    
    def to_s(d)
      return nil if d == nil
      return "" + d.to_s
    end
    
    def get_bag(d)
      return nil
    end
    
    def get_table(d)
      return nil
    end
    
    def has_structure(d)
      return false
    end
    
    def equals(d1,d2)
      return true if d1 == nil && d2 == nil
      return true if d1 == nil && "" + d2.to_s == ""
      return true if "" + d1.to_s == "" && d2 == nil
      return "" + d1.to_s == "" + d2.to_s
    end
    
    def to_datum(str)
      return nil if str == nil
      return ::Coopy::SimpleCell.new(str)
    end
    
  end
end