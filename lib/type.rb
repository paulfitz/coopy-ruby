#!/bin/env ruby
# encoding: utf-8

begin 
  class Type 
    
    def Type._typeof(v)
      _g = v.class.to_s
      case(_g)
      when "TrueClass"
        return ValueType.tbool
      when "FalseClass"
        return ValueType.tbool
      when "String"
        return ValueType.tclass(String)
      when "Fixnum"
        return ValueType.tint
      when "Float"
        return ValueType.tfloat
      when "Proc"
        return ValueType.tfunction
      when "NilClass"
        return ValueType.tnull
      when "Hash"
        return ValueType.tobject
      else
        return ValueType.tclass(v.class) if v.respond_to?("class")
        return ValueType.tunknown
      end
    end
    
  end
end