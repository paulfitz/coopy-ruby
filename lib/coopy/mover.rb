#!/bin/env ruby
# encoding: utf-8

module Coopy
  class Mover 
    
    def initialize
    end
    
    def Mover.move_units(units)
      isrc = Array.new
      idest = Array.new
      len = units.length
      ltop = -1
      rtop = -1
      in_src = {}
      in_dest = {}
      begin
        _g = 0
        while(_g < len) 
          i = _g
          _g+=1
          unit = units[i]
          if unit.l >= 0 && unit.r >= 0 
            ltop = unit.l if ltop < unit.l
            rtop = unit.r if rtop < unit.r
            begin
              in_src[unit.l] = i
              i
            end
            begin
              in_dest[unit.r] = i
              i
            end
          end
        end
      end
      v = nil
      begin
        _g1 = 0
        _g = ltop + 1
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          v = in_src[i]
          isrc.push(v) if v != nil
        end
      end
      begin
        _g1 = 0
        _g = rtop + 1
        while(_g1 < _g) 
          i = _g1
          _g1+=1
          v = in_dest[i]
          idest.push(v) if v != nil
        end
      end
      return ::Coopy::Mover.move_without_extras(isrc,idest)
    end
    
    def Mover.move_with_extras(isrc,idest)
      len = isrc.length
      len2 = idest.length
      in_src = {}
      in_dest = {}
      begin
        _g = 0
        while(_g < len) 
          i = _g
          _g+=1
          begin
            in_src[isrc[i]] = i
            i
          end
        end
      end
      begin
        _g = 0
        while(_g < len2) 
          i = _g
          _g+=1
          begin
            in_dest[idest[i]] = i
            i
          end
        end
      end
      src = Array.new
      dest = Array.new
      v = nil
      begin
        _g = 0
        while(_g < len) 
          i = _g
          _g+=1
          v = isrc[i]
          src.push(v) if in_dest.include?(v)
        end
      end
      begin
        _g = 0
        while(_g < len2) 
          i = _g
          _g+=1
          v = idest[i]
          dest.push(v) if in_src.include?(v)
        end
      end
      return ::Coopy::Mover.move_without_extras(src,dest)
    end
    
    def Mover.move_without_extras(src,dest)
      return nil if src.length != dest.length
      return [] if src.length <= 1
      len = src.length
      in_src = {}
      blk_len = {}
      blk_src_loc = {}
      blk_dest_loc = {}
      begin
        _g = 0
        while(_g < len) 
          i = _g
          _g+=1
          begin
            in_src[src[i]] = i
            i
          end
        end
      end
      ct = 0
      in_cursor = -2
      out_cursor = 0
      _next = nil
      blk = -1
      v = nil
      while(out_cursor < len) 
        v = dest[out_cursor]
        _next = in_src[v]
        if _next != in_cursor + 1 
          blk = v
          ct = 1
          blk_src_loc[blk] = _next
          blk_dest_loc[blk] = out_cursor
        else 
          ct+=1
        end
        blk_len[blk] = ct
        in_cursor = _next
        out_cursor+=1
      end
      blks = Array.new
      _it = ::Rb::RubyIterator.new(blk_len.keys)
      while(_it.has_next) do
        k = _it._next
        blks.push(k)
      end
      blks.sort {|a,b|
        return blk_len[b] - blk_len[a]
      }
      moved = Array.new
      while(blks.length > 0) 
        blk1 = blks.shift
        blen = blks.length
        ref_src_loc = blk_src_loc[blk1]
        ref_dest_loc = blk_dest_loc[blk1]
        i = blen - 1
        while(i >= 0) 
          blki = blks[i]
          blki_src_loc = blk_src_loc[blki]
          to_left_src = blki_src_loc < ref_src_loc
          to_left_dest = blk_dest_loc[blki] < ref_dest_loc
          if to_left_src != to_left_dest 
            ct1 = blk_len[blki]
            begin
              _g = 0
              while(_g < ct1) 
                j = _g
                _g+=1
                moved.push(src[blki_src_loc])
                blki_src_loc+=1
              end
            end
            blks.slice!(i,1)
          end
          i-=1
        end
      end
      return moved
    end
    
  end
end