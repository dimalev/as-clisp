package com.clisp {
  public class CLispMacros extends CLispCons implements IFunction {
    protected var mArguments:CLispCons;
    protected var mBody:CLispCons;

    public static function fromCons(definition:CLispCons):CLispMacros {
      var inargs:CLispCons = definition.car as CLispCons;
      var body:CLispCons = definition.cdr as CLispCons;
      return new CLispMacros(inargs, body);
    }

    public function CLispMacros(args:CLispCons, body:CLispCons) {
      super(args, body);
      mArguments = args;
      mBody = body;
    }

    public function execute(se:ScriptEngine, sc:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      return se.execute(sc, expand(se, sc, scope, args), scope);//res;
    }

    public function expand(se:ScriptEngine, sc:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
      var newScope:uint = scope + 1;
      var bd:Bindings = new Bindings;
      var an:CLispCons = mArguments;
      var av:CLispCons = args;
      var optional:Boolean = false;
      while(!CLispNil.NIL.equals(an) && !CLispNil.NIL.equals(av)) {
        var argName:CLispSymbolRaw = (an.car) as CLispSymbolRaw;
        if(CLispSymbolRaw.REST.equals(argName)) {
          an = an.cdr as CLispCons;
          argName = an.car as CLispSymbolRaw;
          bd.setBinding(argName.rawName, av);
          an = an.cdr as CLispCons;
          av = av.cdr as CLispCons;
          break;
        } else if(CLispSymbolRaw.OPTIONAL.equals(argName)) {
          optional = true;
          an = an.cdr as CLispCons;
          argName = an.car as CLispSymbolRaw;
        }
        bd.setBinding(argName.rawName, av.car);
        an = an.cdr as CLispCons;
        av = av.cdr as CLispCons;
      }
      if(!CLispNil.NIL.equals(an)) {
        argName = (an.car) as CLispSymbolRaw;
        if(CLispSymbolRaw.REST.equals(argName)) {
          an = an.cdr as CLispCons;
          argName = an.car as CLispSymbolRaw;
          bd.setBinding(argName.rawName, CLispNil.NIL);
          an = an.cdr as CLispCons;
        } else if(!optional && !CLispSymbolRaw.OPTIONAL.equals(argName))
          throw new Error("Not enough arguments! Need: " + mArguments.toString() + " got: " + args.toString());
      }
      sc.setBindings(bd, newScope);
      var res:CLispSymbol = CLispNil.NIL;
      var b:CLispCons = mBody;
      while(!CLispNil.NIL.equals(b)) {
        res = se.execute(sc, b.car, newScope);
        b = b.cdr as CLispCons;
      }
      sc.setBindings(null, newScope);
      return res;
    }
  }
}
