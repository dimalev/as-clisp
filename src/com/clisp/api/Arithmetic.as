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
    public static function plague(b:Bindings):void {
      b.setBinding("+", new InternalFunction(summ));
      b.setBinding("-", new InternalFunction(diff));
      b.setBinding("*", new InternalFunction(mult));
      b.setBinding("/", new InternalFunction(div));
    }

    public static function div(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispNumber)) {
        trace("Number expected!");
        throw new Error("Number expected!");
      }
      var n:Number = (arg as CLispNumber).number;
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        arg = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) {
          trace("Number expected!");
          throw new Error("Number expected!");
        }
        n /= (arg as CLispNumber).number;
        args = args.cdr;
      }
      return new CLispNumber(n);
    }

    public static function mult(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispNumber)) {
        trace("Number expected!");
        throw new Error("Number expected!");
      }
      var n:Number = (arg as CLispNumber).number;
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        arg = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) {
          trace("Number expected!");
          throw new Error("Number expected!");
        }
        n *= (arg as CLispNumber).number;
        args = args.cdr;
      }
      return new CLispNumber(n);
    }

    public static function diff(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispNumber)) {
        trace("Number expected!");
        throw new Error("Number expected!");
      }
      var n:Number = (arg as CLispNumber).number;
      args = args.cdr;
      while(!CLispNil.NIL.equals(args)) {
        arg = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) {
          trace("Number expected!");
          throw new Error("Number expected!");
        }
        n -= (arg as CLispNumber).number;
        args = args.cdr;
      }
      return new CLispNumber(n);
    }

    public static function summ(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var n:Number = 0;
      while(!CLispNil.NIL.equals(args)) {
        var arg:CLispSymbol = se.execute(ctx, args.car, scope);
        if(!(arg is CLispNumber)) {
          trace("Number expected!");
          throw new Error("Number expected!");
        }
        n += (arg as CLispNumber).number;
        args = args.cdr;
      }
      return new CLispNumber(n);
    }
  }
}