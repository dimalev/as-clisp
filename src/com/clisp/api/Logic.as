package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispNumber;
  import com.clisp.CLispNil;
  import com.clisp.CLispCons;
  import com.clisp.InternalFunction;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;
  import com.clisp.Bindings;

  public class Logic {
    [Macros(name="<")]
    public function less(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var prev:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(prev is CLispNumber)) {
        trace("Number expected!");
        throw new Error("Number expected!");
      }
      args = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(args)) {
        var next:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!((prev as CLispNumber).number < (next as CLispNumber).number)) return CLispNil.NIL;
        prev = next;
        args = args.cdr as CLispCons;
      }
      return new CLispSymbolRaw("t");
    }

    [Macros(name="=")]
    public function equal(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var first:CLispSymbol = se.execute(ctx, args.car, scope);
      args = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(args)) {
        var next:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!first.equals(next)) return CLispNil.NIL;
        args = args.cdr as CLispCons;
      }
      return new CLispSymbolRaw("t");
    }
  }
}
