#!/bin/env ruby
# encoding: utf-8

begin 
  class List 
    
    def initialize
      @length = 0
    end
    
    protected
    
    attr_accessor :h
    attr_accessor :q
    
    public
    
    attr_accessor :length
    
    def add(item)
      x = [item]
      if @h == nil 
        @h = x
      else 
        @q[1] = x
      end
      @q = x
      @length+=1
    end
    
    def iterator 
      return { h: @h, has_next: lambda {
        return @h != nil
      }, _next: lambda {
        return nil if @h == nil
        x = @h[0]
        @h = @h[1]
        return x
      }}
    end
    
  end
end