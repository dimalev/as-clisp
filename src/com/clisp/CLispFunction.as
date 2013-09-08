package com.clisp {
  public class CLispFunction extends CLispCons implements IFunction {
    protected var mArguments:CLispCons;
    protected var mBody:CLispCons;

    public function CLispFunction(args:CLispCons, body:CLispCons) {
      super(args, body);
      mArguments = args;
      mBody = body;
    }

    public function execute(se:ScriptEngine, sc:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var newScope:uint = scope + 1;
      var bd:Bindings = new Bindings;
      var an:CLispCons = mArguments;
      var av:CLispCons = args;
      while(!CLispNil.NIL.equals(an) && !CLispNil.NIL.equals(av)) {
        bd.setBinding(((an.car) as CLispSymbolRaw).rawName, se.execute(sc, av.car, scope));
        an = an.cdr;
        av = av.cdr;
      }
      sc.setBindings(bd, newScope);
      var res:CLispSymbol = CLispNil.NIL;
      var b:CLispCons = mBody;
      while(!CLispNil.NIL.equals(b)) {
        res = se.execute(sc, b.car, newScope);
        b = b.cdr;
      }
      sc.setBindings(null, newScope);
      return res;
    }
  }
}
