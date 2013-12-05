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
      else
        begin
          c = __define_feature__("rb.Boot.getClass",v.__class__)
          return ValueType.tclass(c) if c != nil
          return ValueType.tunknown
        end
      end
    end
    
  end
end