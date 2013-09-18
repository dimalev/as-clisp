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

  public class LabelsInternalFunction extends CLispSymbol implements IFunction {
    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var newScope:uint = scope + 1;
      var bd:Bindings = new Bindings;
      var iter:CLispCons = args.car as CLispCons;
      while(!CLispNil.NIL.equals(iter)) {
        var def:CLispCons = iter.car as CLispCons;
        var name:CLispSymbol = def.car;
        if(!(name is CLispSymbolRaw)) throw new Error(name.toString() + " is not a Symbol!");
        var defbody:CLispCons = def.cdr as CLispCons;
        bd.setBinding((name as CLispSymbolRaw).rawName, CLispFunction.fromCons(defbody));
        iter = iter.cdr as CLispCons;
      }
      ctx.setBindings(bd, newScope);

      var res:CLispSymbol = CLispNil.NIL;
      var b:CLispCons = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(b)) {
        res = se.execute(ctx, b.car, newScope);
        b = b.cdr as CLispCons;
      }

      ctx.setBindings(null, newScope);

      return res;
    }
  }
}