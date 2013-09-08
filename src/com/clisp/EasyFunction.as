package com.clisp {
  public class EasyFunction extends CLispSymbol implements IFunction {
    private var mF:Function;

    public function execute(se:ScriptEngine, ctx:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var args2:Array = new Array;
      while(!CLispNil.NIL.equals(args)) {
        var arg:CLispSymbol = se.execute(ctx, args.car, scope);
        if(arg is CLispNumber) args2.push((arg as CLispNumber).number);
        else if(arg is CLispString) args2.push((arg as CLispString).value);
        else if(CLispNil.NIL.equals(arg)) args2.push(null);
        else args2.push(arg);
        args = args.cdr;
      }
      var res:* = null;
      try {
        res = mF(args2);
      } catch(e:Error) {
        trace("(EE) Error occurred while processing API request:");
        trace(e);
      }
      if(res == null) return CLispNil.NIL;
      if((res is Number) || (res is uint)) return new CLispNumber(res);
      if(res is String) return new CLispString(res);
      if(res is CLispSymbol) return res;
      trace("(EE) Return type cannot be converted into Common Lisp object: " + res);
      return null;
    }

    public function EasyFunction(f:Function) {
      mF = f;
    }
  }
}