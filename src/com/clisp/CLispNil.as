package com.clisp {
  public class CLispNil extends CLispCons {
    public static const NIL:CLispNil = new CLispNil();
    public function CLispNil() { super(this, this); }

    public override function toString():String { return "nil"; }
    protected override function toString2():String { return ""; }

    public override function get type():CLispSymbolRaw { return CLispSymbolRaw.NULL; }

    public override function equals(that:CLispSymbol):Boolean {
      return that is CLispNil;
    }
  }
}