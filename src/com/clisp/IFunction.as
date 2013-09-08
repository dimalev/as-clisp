package com.clisp {
  public interface IFunction {
    function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol;
  }
}