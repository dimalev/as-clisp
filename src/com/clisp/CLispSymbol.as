package com.clisp {
  public class CLispSymbol {
    public function toString():String { return "XXX"; }

    public function get type():CLispSymbolRaw { return null; }

    public function equals(that:CLispSymbol):Boolean { return this == that; }
  }
}