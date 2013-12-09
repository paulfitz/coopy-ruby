#!/bin/env ruby
# encoding: utf-8

module Sys::Io
  class FileHandle
    ISENUM__ = true
    attr_accessor :tag
    attr_accessor :index
    attr_accessor :params
    def initialize(t,index,p = nil ) @tag = t; @index = index; @params = p; end
    
    CONSTRUCTS__ = []
  end
end
