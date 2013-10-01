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

  public class Arithmetic {
    [Macros(name="/")]
    public function div(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
      var n:Number = (arg as CLispNumber).number;
      args = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(args)) {
        arg = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
        n /= (arg as CLispNumber).number;
        args = args.cdr as CLispCons;
      }
      return new CLispNumber(n);
    }

    [Macros(name="*")]
    public function mult(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
      var n:Number = (arg as CLispNumber).number;
      args = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(args)) {
        arg = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
        n *= (arg as CLispNumber).number;
        args = args.cdr as CLispCons;
      }
      return new CLispNumber(n);
    }

    [Macros(name="-")]
    public function diff(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
      var n:Number = (arg as CLispNumber).number;
      args = args.cdr as CLispCons;
      if(CLispNil.NIL.equals(args)) n = -n;
      else
        while(!CLispNil.NIL.equals(args)) {
          arg = se.execute(ctx, args.car, scope);
          if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
          n -= (arg as CLispNumber).number;
          args = args.cdr as CLispCons;
        }
      return new CLispNumber(n);
    }

    [Macros(name="+")]
    public function summ(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var n:Number = 0;
      while(!CLispNil.NIL.equals(args)) {
        var arg:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) throw new Error("Number expected! got " + arg);
        n += (arg as CLispNumber).number;
        args = args.cdr as CLispCons;
      }
      return new CLispNumber(n);
    }
  }
}