package com.clisp {
  import com.clisp.api.PrognInternalFunction;
  import com.clisp.api.DefInternalFunction;
  import com.clisp.api.Arithmetic;
  import com.clisp.api.Logic;

  public class ScriptEngine {
    public function ScriptEngine() {
    }

    public function buildDefaultContext():ScriptContext {
      var ctx:ScriptContext = new ScriptContext;
      var gl:Bindings = new Bindings;
      ctx.setBindings(gl, ScriptContext.GLOBAL_SCOPE);

      Arithmetic.plague(gl);
      Logic.plague(gl);

      // special functions
      gl.setBinding("progn", new PrognInternalFunction(this));
      gl.setBinding("def", new DefInternalFunction);
      gl.setBinding("set", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var name:CLispSymbol = se.execute(ctx, args.car, scope);
          var value:CLispSymbol = se.execute(ctx, args.cdar, scope);
          ctx.setAttribute((name as CLispSymbolRaw).rawName, value, scope);
          return value;
        }));
      gl.setBinding("setq", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var name:CLispSymbol = args.car;
          var value:CLispSymbol = se.execute(ctx, args.cdar, scope);
          ctx.setAttribute((name as CLispSymbolRaw).rawName, value, scope);
          return value;
        }));
      gl.setBinding("if", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var condition:CLispSymbol = se.execute(ctx, args.car, scope);
          var toExec:CLispSymbol = CLispNil.NIL.equals(condition) ? args.cdr.cdr.car : args.cdar;
          return se.execute(ctx, toExec, scope);
        }));
      return ctx;
    }

    public function execute(ctx:ScriptContext, prog:CLispSymbol, scope:uint = ScriptContext.GLOBAL_SCOPE):CLispSymbol {
      if(CLispNil.NIL.equals(prog)) return prog;
      if(prog is Escape) return (prog as Escape).symbol;
      if(prog is CLispSymbolRaw) {
        return ctx.getAttribute((prog as CLispSymbolRaw).rawName);
      }
      if((prog is CLispNumber) ||
         (prog is CLispString)) return prog;
      if(prog is CLispCons) {
        var car:CLispSymbol = execute(ctx, (prog as CLispCons).car);
        var cdr:CLispCons = (prog as CLispCons).cdr;
        if(car is IFunction) {
          return (car as IFunction).execute(this, ctx, scope, cdr);
        } else {
          trace("Not a function: " + car.toString());
        }
      }
      return null;
    }
  }
}