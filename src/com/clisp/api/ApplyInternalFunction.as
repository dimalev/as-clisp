package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.CLispCons;
  import com.clisp.CLispFunction;
  import com.clisp.CLispNil;
  import com.clisp.IFunction;
  import com.clisp.Bindings;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;

  public class ApplyInternalFunction extends CLispSymbol implements IFunction {
    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var f:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(f is IFunction)) throw new Error("Not a function to execute! " + f.toString());
      var va:Vector.<CLispSymbol> = new Vector.<CLispSymbol>;
      var iter:CLispCons = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(iter)) {
        var aa:CLispSymbol = se.execute(ctx, iter.car, scope);
        va.unshift(aa);
        iter = iter.cdr as CLispCons;
      }
      var restsymbol:CLispSymbol = va.shift();
      if(!(restsymbol is CLispCons)) throw new Error("Not a cons in rest for apply function! " + restsymbol.toString());
      var targs:CLispCons = restsymbol as CLispCons;
      while(va.length > 0) targs = new CLispCons(va.shift(), targs);
      return (f as IFunction).execute(se, ctx, scope, targs);
    }
  }
}