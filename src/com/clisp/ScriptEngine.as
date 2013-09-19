package com.clisp {
  import com.clisp.api.PrognInternalFunction;
  import com.clisp.api.DefunInternalFunction;
  import com.clisp.api.DefmacroInternalFunction;
  import com.clisp.api.LabelsInternalFunction;
  import com.clisp.api.LetInternalFunction;
  import com.clisp.api.SetfInternalFunction;
  import com.clisp.api.BackquoteInternalFunction;
  import com.clisp.api.ApplyInternalFunction;
  import com.clisp.api.Arithmetic;
  import com.clisp.api.Strings;
  import com.clisp.api.Logic;

  public class ScriptEngine {
    [Embed(source="../../..//res/lisp.l", mimeType="application/octet-stream")]
    public var rawLisp:Class;

    public function ScriptEngine() {
    }

    public function buildDefaultContext():ScriptContext {
      var ctx:ScriptContext = new ScriptContext;
      var gl:Bindings = new Bindings;
      ctx.setBindings(gl, ScriptContext.GLOBAL_SCOPE);

      ctx.importCustom(new Arithmetic);
      ctx.importCustom(new Strings);
      ctx.importCustom(new Logic);

      // special functions
      gl.setBinding("progn", new PrognInternalFunction(this));
      gl.setBinding("defun", new DefunInternalFunction);
      gl.setBinding("labels", new LabelsInternalFunction);
      gl.setBinding("let", new LetInternalFunction);
      gl.setBinding("defmacro", new DefmacroInternalFunction);
      gl.setBinding("apply", new ApplyInternalFunction);
      gl.setBinding("backquote", new BackquoteInternalFunction);
      gl.setBinding("setf", new SetfInternalFunction);
      gl.setBinding("cons", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var one:CLispSymbol = se.execute(ctx, args.car, scope);
          var two:CLispSymbol = se.execute(ctx, args.cadr, scope);
          return new CLispCons(one, two);
        }));
      gl.setBinding("symbol-name", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var symbol:CLispSymbol = se.execute(ctx, args.car, scope);
          return new CLispString((symbol as CLispSymbolRaw).rawName);
        }));
      gl.setBinding("intern", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var name:CLispSymbol = se.execute(ctx, args.car, scope);
          return new CLispSymbolRaw((name as CLispString).value);
        }));
      gl.setBinding("car", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var one:CLispSymbol = se.execute(ctx, args.car, scope);
          return (one as CLispCons).car;
        }));
      gl.setBinding("cdr", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var one:CLispSymbol = se.execute(ctx, args.car, scope);
          return (one as CLispCons).cdr;
        }));
      gl.setBinding("typep", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var one:CLispSymbol = se.execute(ctx, args.car, scope);
          var two:CLispSymbol = se.execute(ctx, args.cadr, scope);
          if(two.equals(one.type)) return CLispSymbolRaw.T;
          return CLispNil.NIL;
        }));
      gl.setBinding("if", new InternalFunction(
        function(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
          var condition:CLispSymbol = se.execute(ctx, args.car, scope);
          var toExec:CLispSymbol = CLispNil.NIL.equals(condition) ? (args.cdr as CLispCons).cadr : args.cadr;
          return se.execute(ctx, toExec, scope);
        }));

      // Lisp Lisp
      execute(ctx, new LexicalAnalyzer().parse(String(new rawLisp)));
      return ctx;
    }

    public function execute(ctx:ScriptContext, prog:CLispSymbol, scope:uint = 0):CLispSymbol {
      try {
      var caar:CLispSymbol;
      if(CLispNil.NIL.equals(prog)) return prog;
      if(prog is CLispSymbolRaw) {
        return ctx.getAttribute((prog as CLispSymbolRaw).rawName);
      }
      if((prog is CLispNumber) ||
         (prog is CLispString)) return prog;
      if(prog is CLispCons) {
        var car:CLispSymbol = (prog as CLispCons).car;
        var cdr:CLispCons = (prog as CLispCons).cdr as CLispCons;
        if(car is CLispSymbolRaw) {
          if(CLispSymbolRaw.QUOTE.equals(car)) return cdr.car;
          if(CLispSymbolRaw.SHARP_QUOTE.equals(car)) {
            var trg:CLispSymbol = cdr.car;
            if(trg is CLispSymbolRaw) return ctx.getAttribute((trg as CLispSymbolRaw).rawName);
            if(trg is CLispCons) {
              caar = (trg as CLispCons).car;
              if(CLispSymbolRaw.LAMBDA.equals(caar))
                return CLispFunction.fromCons((trg as CLispCons).cdr as CLispCons);
            }
          }
          var f:CLispSymbol = ctx.getAttribute((car as CLispSymbolRaw).rawName);
          if(f is IFunction) return (f as IFunction).execute(this, ctx, scope, cdr);
        }
        if(car is CLispCons) {
          caar = (car as CLispCons).car;
          if(CLispSymbolRaw.LAMBDA.equals(caar))
            return CLispFunction.fromCons((car as CLispCons).cdr as CLispCons);
        }
        throw new Error("Not a function or lambda is first argument: " + prog.toString());
      }
      } catch(e:Error) {
        trace("Error executing:");
        trace(prog.toString());
        throw e;
      }
      return null;
    }
  }
}