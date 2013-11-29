module Coopy
  public final class ChangeType extends enum {
    public static const __isenum : Boolean = true
    public function ChangeType( t : String, index : int, p : Array = nil ) : void { this.tag = t; this.index = index; this.params = p; }
    public static var BOTH_CHANGE : ChangeType = new ChangeType("BOTH_CHANGE",3)
    public static var LOCAL_CHANGE : ChangeType = new ChangeType("LOCAL_CHANGE",2)
    public static var NOTE_CHANGE : ChangeType = new ChangeType("NOTE_CHANGE",5)
    public static var NO_CHANGE : ChangeType = new ChangeType("NO_CHANGE",0)
    public static var REMOTE_CHANGE : ChangeType = new ChangeType("REMOTE_CHANGE",1)
    public static var SAME_CHANGE : ChangeType = new ChangeType("SAME_CHANGE",4)
    public static var __constructs__ : Array = ["NO_CHANGE","REMOTE_CHANGE","LOCAL_CHANGE","BOTH_CHANGE","SAME_CHANGE","NOTE_CHANGE"];
  }
}
