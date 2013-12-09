#!/bin/env ruby
# encoding: utf-8

module Rb
  class RubyIterator 
    
    def initialize(x)
      if x.respond_to?("each") 
        @ref = x.each
        @at = 0
        @len = x.size
      elsif x.respond_to?("iterator") 
        @ref = x.iterator
        @at = -1
        @at = -2 if !@ref.respond_to?("has_next")
      else 
        @ref = x
        @at = -2
      end
    end
    
    protected
    
    attr_accessor :ref
    attr_accessor :at
    attr_accessor :len
    
    public
    
    def has_next 
      return @ref.has_next if @at == -1
      return @ref[:has_next].call if @at == -2
      return @at < @len
    end
    
    def _next 
      return @ref._next if @at == -1
      return @ref[:_next].call if @at == -2
      @at+=1
      return @ref.next
    end
    
  end
end