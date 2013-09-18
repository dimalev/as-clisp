package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.CLispCons;
  import com.clisp.CLispFunction;
  import com.clisp.IFunction;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;

  public class DefunInternalFunction extends CLispSymbol implements IFunction {
    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var name:CLispSymbol = args.car;
      if(!(name is CLispSymbolRaw)) throw new Error("Name should be a Symbol!");
      var f:CLispFunction = CLispFunction.fromCons(args.cdr as CLispCons);
      ctx.setAttribute((name as CLispSymbolRaw).rawName, f, ScriptContext.GLOBAL_SCOPE);
      return f;
    }
  }
}