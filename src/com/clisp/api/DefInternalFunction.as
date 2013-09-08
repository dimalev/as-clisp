package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.CLispCons;
  import com.clisp.CLispFunction;
  import com.clisp.CLispNil;
  import com.clisp.IFunction;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;

  public class DefInternalFunction extends CLispSymbol implements IFunction {
    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var name:CLispSymbol = args.car;
      if(name is CLispCons) name = se.execute(ctx, name, scope);
      var inargs:CLispCons = args.cdr.car as CLispCons;
      var body:CLispCons = args.cdr.cdr;
      var f:CLispFunction = new CLispFunction(inargs, body);
      ctx.setAttribute((name as CLispSymbolRaw).rawName, f, scope);
      return f;
    }
  }
}