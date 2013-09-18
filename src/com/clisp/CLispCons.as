package com.clisp {
  public class CLispCons extends CLispSymbol {
    public var car:CLispSymbol;
    public var cdr:CLispSymbol;

    public function get cadr():CLispSymbol { return (cdr as CLispCons).car; }
    public function get cdar():CLispSymbol { return (car as CLispCons).cdr; }

    public function CLispCons(car:CLispSymbol, cdr:CLispSymbol) {
      this.car = car;
      this.cdr = cdr;
    }

    public override function get type():CLispSymbolRaw { return CLispSymbolRaw.CONS; }

    public override function toString():String {
      var spec:String = special();
      if(spec) return spec;
      if(CLispNil.NIL.equals(cdr)) return "(" + car.toString() + ")";
      if(cdr is CLispCons) return "(" + car.toString() + " " + (cdr as CLispCons).toString2() + ")";
      return "(" + car.toString() + " . " + cdr.toString() + ")";
    }

    protected function toString2():String {
      var spec:String = special();
      if(spec) return spec;
      if(CLispNil.NIL.equals(cdr)) return car.toString();
      if(cdr is CLispCons) return car.toString() + " " + (cdr as CLispCons).toString2();
      return car.toString() + " . " + cdr.toString();
    }

    protected function special():String {
      if(CLispSymbolRaw.QUOTE.equals(car)) return "'" + cdr.toString();
      if(CLispSymbolRaw.BACKQUOTE.equals(car)) return "`" + (cdr as CLispCons).toString2();
      if(CLispSymbolRaw.SHARP_QUOTE.equals(car)) return "#'" + cdr.toString();
      if(CLispSymbolRaw.COMMA.equals(car)) return "," + (cdr as CLispCons).toString2();
      if(CLispSymbolRaw.COMMA_AT.equals(car)) return ",@" + (cdr as CLispCons).toString2();
      return null;
    }

    public override function equals(that:CLispSymbol):Boolean {
      if(!that is CLispCons) return false;
      var thatcons:CLispCons = that as CLispCons;
      if(CLispNil.NIL.equals(car)) {
        if(!CLispNil.NIL.equals(thatcons.car)) return false;
      } else {
        if(!car.equals(thatcons.car)) return false;
      }
      if(cdr == null) {
        if(thatcons.cdr != null) return false;
      } else {
        if(!cdr.equals(thatcons.cdr)) return false;
      }
      return true;
    }
  }
}