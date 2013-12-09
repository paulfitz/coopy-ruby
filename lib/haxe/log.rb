#!/bin/env ruby
# encoding: utf-8

module Haxe
  class Log 
    
    class << self
    attr_accessor :_trace
    end
    @_trace = lambda {|v,infos = nil|
      ::Rb::Boot.__trace(v,infos)
    }
    
  end
end