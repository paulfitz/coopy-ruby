#!/bin/env ruby
# encoding: utf-8

module Sys::Io
  class File 
    
    def File.get_content(path)
      return IO.read(path)
    end
    
    def File.save_content(path,content)
      IO.write(path,content)
    end
    
  end
end