package com.clisp {
  public class CLispSymbolRaw extends CLispSymbol {
    public var rawName:String;

    public function CLispSymbolRaw(rawName:String) {
      this.rawName = rawName;
    }

    public override function toString():String { return rawName; }

    public override function equals(that:CLispSymbol):Boolean {
      if(!(that is CLispSymbolRaw)) return false;
      return rawName == (that as CLispSymbolRaw).rawName;
    }
  }
}