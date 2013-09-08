package com.clisp {
  public class Escape extends CLispSymbol {
    public var symbol:CLispSymbol;

    public function Escape(symbol:CLispSymbol) {
      this.symbol = symbol;
    }

    public override function toString():String { return "'" + symbol.toString(); }
  }
}