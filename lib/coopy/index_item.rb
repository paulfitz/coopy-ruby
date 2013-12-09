#!/bin/env ruby
# encoding: utf-8

module Coopy
  class IndexItem 
    
    def initialize
    end
    
    attr_accessor :lst
    
    def add(i)
      @lst = Array.new if @lst == nil
      @lst.push(i)
      return @lst.length
    end
    
  end
end