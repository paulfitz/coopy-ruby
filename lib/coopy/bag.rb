#!/bin/env ruby
# encoding: utf-8

module Coopy
  class Bag 
    def getItem(x) puts "Abstract Bag.getItem called" end
    def getItemView() puts "Abstract Bag.getItemView called" end
  end
end