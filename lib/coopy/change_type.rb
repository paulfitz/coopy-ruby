module Coopy
  class ChangeType
    ISENUM__ = true
    attr_accessor :tag
    attr_accessor :index
    attr_accessor :params
    def initialize(t,index,p = nil ) @tag = t; @index = index; @params = p; end
    
    def ChangeType.both_change() ChangeType.new("BOTH_CHANGE",3) end
    def ChangeType.local_change() ChangeType.new("LOCAL_CHANGE",2) end
    def ChangeType.note_change() ChangeType.new("NOTE_CHANGE",5) end
    def ChangeType.no_change() ChangeType.new("NO_CHANGE",0) end
    def ChangeType.remote_change() ChangeType.new("REMOTE_CHANGE",1) end
    def ChangeType.same_change() ChangeType.new("SAME_CHANGE",4) end
    CONSTRUCTS__ = ["NO_CHANGE","REMOTE_CHANGE","LOCAL_CHANGE","BOTH_CHANGE","SAME_CHANGE","NOTE_CHANGE"]
  end
end
