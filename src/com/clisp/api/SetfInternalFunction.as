package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.CLispCons;
  import com.clisp.CLispMacros;
  import com.clisp.IFunction;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;

  public class SetfInternalFunction extends CLispSymbol implements IFunction {
    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var target:CLispSymbol = args.car;
      var value:CLispSymbol = se.execute(ctx, args.cadr, scope);
      if(target is CLispSymbolRaw) define(ctx, (target as CLispSymbolRaw), value);
      else if(target is CLispCons) {
        var operation:CLispSymbol = (target as CLispCons).car;
        if(operation is CLispSymbolRaw &&
           (ctx.getAttribute((operation as CLispSymbolRaw).rawName) is CLispMacros)) {
          var macros:CLispMacros = (ctx.getAttribute((operation as CLispSymbolRaw).rawName) as CLispMacros)
          operation = macros.expand(se, ctx, scope, (target as CLispCons).cdr as CLispCons);
          if(operation is CLispSymbolRaw) define(ctx, (operation as CLispSymbolRaw), value);
          else if(operation is CLispCons) {
            target = operation;
            operation = (target as CLispCons).car;
          } else throw new Error("Setf cannot set " + operation);
        }
        if(operation is CLispSymbolRaw) {
          var opname:String = (operation as CLispSymbolRaw).rawName;
          var holder:CLispSymbol;
          if(opname == "CAR") {
            holder = se.execute(ctx, (target as CLispCons).cadr, scope);
            (holder as CLispCons).car = value;
          } else if(opname == "CDR") {
            holder = se.execute(ctx, (target as CLispCons).cadr, scope);
            (holder as CLispCons).cdr = value;
          } else throw new Error("Setf support only car and cdr as functions to set. given: " + opname);
        } else throw new Error("Setf cannot set " + operation);
      } else throw new Error("Setf cannot set " + target);
      return value;
    }

    private function define(ctx:ScriptContext, symbol:CLispSymbolRaw, value:CLispSymbol):void {
      var attscope:Number = ctx.getAttributeScope((symbol as CLispSymbolRaw).rawName);
      ctx.setAttribute((symbol as CLispSymbolRaw).rawName, value,
                       isNaN(attscope) ? ScriptContext.GLOBAL_SCOPE : attscope);
    }
  }
}