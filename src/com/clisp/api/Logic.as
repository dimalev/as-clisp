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
    public static function plague(b:Bindings):void {
      b.setBinding("=", new InternalFunction(equal));
      b.setBinding("not", new InternalFunction(not));
      b.setBinding("and", new InternalFunction(and));
      b.setBinding("or", new InternalFunction(or));
      b.setBinding("<", new InternalFunction(less));
    }

    public static function less(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var prev:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(prev is CLispNumber)) {
        trace("Number expected!");
        throw new Error("Number expected!");
      }
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        var next:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!((prev as CLispNumber).number < (next as CLispNumber).number)) return CLispNil.NIL;
        prev = next;
        args = args.cdr;
      }
      return new CLispSymbolRaw("t");
    }

    public static function equal(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var first:CLispSymbol = se.execute(ctx, args.car, scope);
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        var next:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!first.equals(next)) return CLispNil.NIL;
        args = args.cdr;
      }
      return new CLispSymbolRaw("t");
    }

    public static function and(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var first:CLispSymbol = se.execute(ctx, args.car, scope);
      if(CLispNil.NIL.equals(first)) return CLispNil.NIL;
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        var next:CLispSymbol = se.execute(ctx, args.car, scope);
        if(CLispNil.NIL.equals(next)) return CLispNil.NIL;
        args = args.cdr;
      }
      return new CLispSymbolRaw("t");
    }

    public static function or(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var first:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!CLispNil.NIL.equals(first)) return first;
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        var next:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!CLispNil.NIL.equals(next)) return next;
        args = args.cdr;
      }
      return CLispNil.NIL;
    }

    public static function not(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var first:CLispSymbol = se.execute(ctx, args.car, scope);
      if(CLispNil.NIL.equals(first)) return new CLispSymbolRaw("t");
      return CLispNil.NIL;
    }
  }
}
