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

  public class BackquoteInternalFunction extends CLispSymbol implements IFunction {
    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      return execute2(se, ctx, scope, args.car as CLispCons);
    }

    protected function execute2(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var va:Vector.<CLispSymbol> = new Vector.<CLispSymbol>;
      var iter:CLispCons = args;
      while(!CLispNil.NIL.equals(iter)) {
        var aa:CLispSymbol = iter.car;
        if(aa is CLispCons) {
          var car:CLispSymbol = (aa as CLispCons).car;
          if(CLispSymbolRaw.COMMA.equals(car)) aa = se.execute(ctx, (aa as CLispCons).cadr, scope);
          else if(CLispSymbolRaw.COMMA_AT.equals(car)) {
            var inside:CLispCons = se.execute(ctx, (aa as CLispCons).cadr, scope) as CLispCons;
            var iter2:CLispCons = inside;
            while(!CLispNil.NIL.equals(iter2)) {
              va.unshift(iter2.car);
              iter2 = iter2.cdr as CLispCons;
            }
            aa = null;
          } else aa = execute2(se, ctx, scope, aa as CLispCons);
        }
        if(aa) va.unshift(aa);
        iter = iter.cdr as CLispCons;
      }
      var targs:CLispCons = CLispNil.NIL;
      while(va.length > 0) targs = new CLispCons(va.shift(), targs);
      return targs;
    }
  }
}