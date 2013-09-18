package com.clisp.api {
  import com.clisp.CLispSymbol;
  import com.clisp.CLispNil;
  import com.clisp.CLispCons;
  import com.clisp.CLispNumber;
  import com.clisp.CLispString;
  import com.clisp.InternalFunction;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;
  import com.clisp.Bindings;

  public class Strings {
    public static function plague(b:Bindings):void {
      b.setBinding("concat", new InternalFunction(concat));
      b.setBinding("strlen", new InternalFunction(strlen));
      b.setBinding("substr", new InternalFunction(substr));
    }

    public static function concat(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      var str:String;
      if(arg is CLispString) str = (arg as CLispString).value;
      else if(arg is CLispNumber) str = String((arg as CLispNumber).number);
      else throw new Error("String or number expected! got " + arg);
      args = args.cdr as CLispCons;
      while(!CLispNil.NIL.equals(args)) {
        arg = se.execute(ctx, args.car, scope);
        if(arg is CLispString) str += (arg as CLispString).value;
        else if(arg is CLispNumber) str += (arg as CLispNumber).number;
        else throw new Error("String or number expected! got " + arg);
        args = args.cdr as CLispCons;
      }
      return new CLispString(str);
    }

    public static function strlen(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var arg:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(arg is CLispString)) throw new Error("String expected! got " + arg);
      return new CLispNumber((arg as CLispString).value.length);
    }

    public static function substr(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var str:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(str is CLispString)) throw new Error("String expected! got " + str);
      args = args.cdr as CLispCons;
      var start:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(start is CLispNumber)) throw new Error("Number expected! got " + start);
      args = args.cdr as CLispCons;
      var len:CLispSymbol = se.execute(ctx, args.car, scope);
      if(!(len is CLispNumber)) throw new Error("Number expected! got " + len);
      return new CLispString((str as CLispString).value.substr((start as CLispNumber).number,
                                                               (len as CLispNumber).number));
    }
  }
}