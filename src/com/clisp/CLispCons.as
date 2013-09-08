package com.clisp {
  public class CLispCons extends CLispSymbol {
    public var car:CLispSymbol;
    public var cdr:CLispCons;

    public function get cdar():CLispSymbol { return cdr.car; }
    public function get cadr():CLispCons { return (car as CLispCons).cdr; }

    public function CLispCons(car:CLispSymbol, cdr:CLispCons) {
      this.car = car;
      this.cdr = cdr;
    }

    public override function toString():String { return "(" + car.toString() + " . " + cdr.toString() + ")"; }

    public override function equals(that:CLispSymbol):Boolean {
      if(!that is CLispCons) return false;
      var thatcons:CLispCons = that as CLispCons;
      if(car == null) {
        if(thatcons.car != null) return false;
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