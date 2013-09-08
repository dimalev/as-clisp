package com.clisp {
  public class InternalFunction extends CLispSymbol implements IFunction {
    private var mF:Function;

    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      return mF(se, ctx, scope, args);
    }

    public function InternalFunction(f:Function) {
      mF = f;
    }
  }
}