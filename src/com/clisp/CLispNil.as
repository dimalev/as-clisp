package com.clisp {
  public class CLispNil extends CLispCons {
    public static const NIL:CLispNil = new CLispNil();
    public function CLispNil() { super(null, null); }

    public override function toString():String { return "nil"; }

    public override function equals(that:CLispSymbol):Boolean {
      return that is CLispNil;
    }
  }
}