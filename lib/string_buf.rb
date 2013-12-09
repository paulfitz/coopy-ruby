#!/bin/env ruby
# encoding: utf-8

begin 
  class StringBuf 
    
    def initialize
      @b = ""
    end
    
    # protected - in ruby this doesn't play well with static/inline methods
    
    attr_accessor :b
  end
end