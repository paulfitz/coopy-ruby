module Sys::Io
  public final class FileHandle extends enum {
    public static const __isenum : Boolean = true
    public function FileHandle( t : String, index : int, p : Array = nil ) : void { this.tag = t; this.index = index; this.params = p; }
    public static var __constructs__ : Array = [];
  }
}
