package com.clisp {
  public class CLispString extends CLispSymbol {
    public var value:String;

    public function CLispString(value:String) {
      this.value = value;
    }

    public override function get type():CLispSymbolRaw { return CLispSymbolRaw.STRING; }

    public override function toString():String { return "\"" + value + "\""; }
  }
}