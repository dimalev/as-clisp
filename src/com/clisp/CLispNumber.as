package com.clisp {
  public class CLispNumber extends CLispSymbol {
    public var number:Number;

    public function CLispNumber(value:*) {
      number = Number(value);
    }

    public override function toString():String { return String(number); }

    public override function get type():CLispSymbolRaw { return CLispSymbolRaw.NUMBER; }

    public override function equals(that:CLispSymbol):Boolean {
      if(!(that is CLispNumber)) return false;
      return number == (that as CLispNumber).number;
    }
  }
}