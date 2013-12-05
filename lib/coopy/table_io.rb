module Coopy
  class TableIO 
    
    def initialize
    end
    
    def get_content(name)
      return ::Sys::Io::File.get_content(name)
    end
    
    def save_content(name,txt)
      ::Sys::Io::File.save_content(name,txt)
      return true
    end
    
    def args 
      return Sys.args
    end
    
    def write_stdout(txt)
      Sys.stdout.write_string(txt)
    end
    
    def write_stderr(txt)
      Sys.stderr.write_string(txt)
    end
    
  end
end