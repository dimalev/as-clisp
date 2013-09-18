package com.clisp.operators {
  public class Backquote extends CLispSymbol {
    public var symbol:CLispSymbol;

    public function Backquote(symbol:CLispSymbol) {
      this.symbol = symbol;
    }

    public override function equals(that:CLispSymbol):Boolean {
      if(!(that is Backuote)) return false;
      return symbol.equals((that as Quote).symbol);
    }

    public override function toString():String { return "'" + symbol.toString(); }
  }
}