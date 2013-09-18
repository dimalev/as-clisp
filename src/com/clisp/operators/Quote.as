package com.clisp.operators {
  public class Quote extends CLispSymbol {
    public var symbol:CLispSymbol;

    public function Quote(symbol:CLispSymbol) {
      this.symbol = symbol;
    }

    public override function equals(that:CLispSymbol):Boolean {
      if(!(that is Quote)) return false;
      return symbol.equals((that as Quote).symbol);
    }

    public override function toString():String { return "'" + symbol.toString(); }
  }
}