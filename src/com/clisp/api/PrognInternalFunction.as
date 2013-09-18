package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispCons;
  import com.clisp.CLispNil;
  import com.clisp.IFunction;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;

  public class PrognInternalFunction extends CLispSymbol implements IFunction {
    private var mScritEngine:ScriptEngine;
    public function PrognInternalFunction(se:ScriptEngine) {
      mScritEngine = se;
    }

    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var res:CLispSymbol = CLispNil.NIL;
      while(!CLispNil.NIL.equals(args)) {
        res = mScritEngine.execute(ctx, args.car, scope);
        args = args.cdr as CLispCons;
      }
      return res;
    }
  }
}