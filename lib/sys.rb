begin 
  class Sys 
    
    def Sys.args 
      return ARGV
    end
    
    def Sys.stdout 
      return ::Sys::Io::FileOutput.new(STDOUT)
    end
    
    def Sys.stderr 
      return ::Sys::Io::FileOutput.new(STDERR)
    end
    
  end
end