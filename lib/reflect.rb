#!/bin/env ruby
# encoding: utf-8

begin 
  class Reflect 
    
    def Reflect.fields(o)
      if o.respond_to?("attributes") 
        return o.attributes
      else 
        return o.keys
      end
    end
    
    def Reflect.is_function(f)
      return f.respond_to?("call")
    end
    
  end
end