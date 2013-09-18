package com.clisp {
  public class CLispFunction extends CLispCons implements IFunction {
    protected var mArguments:CLispCons;
    protected var mBody:CLispCons;

    public static function fromCons(definition:CLispCons):CLispFunction {
      var inargs:CLispCons = definition.car as CLispCons;
      var body:CLispCons = definition.cdr as CLispCons;
      return new CLispFunction(inargs, body);
    }

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
      var optional:Boolean = false;
      var key:Boolean = false;
      var rest:Boolean = false;
      var argName:CLispSymbolRaw;
      while(!CLispNil.NIL.equals(an) && !CLispNil.NIL.equals(av)) {
        argName = null;
        if(optional) {
          var argNext:CLispSymbol = an.car;
          if(argNext is CLispCons) {
            argName = (argNext as CLispCons).car as CLispSymbolRaw;
          } else argName = argNext as CLispSymbolRaw;
        } else argName = (an.car) as CLispSymbolRaw;
        if(CLispSymbolRaw.REST.equals(argName)) {
          argName = an.cadr as CLispSymbolRaw;
          var evargs:Vector.<CLispSymbol> = new Vector.<CLispSymbol>;
          while(!CLispNil.NIL.equals(av)) {
            evargs.push(se.execute(sc, av.car, scope));
            av = av.cdr as CLispCons;
          }
          var tail:CLispCons = CLispNil.NIL;
          for(var i:int = evargs.length - 1; i >= 0; --i)
            tail = new CLispCons(evargs[i], tail);
          bd.setBinding(argName.rawName, tail);
          rest = true;
          break;
        } else if(CLispSymbolRaw.OPTIONAL.equals(argName)) {
          an = an.cdr as CLispCons;
          argNext = an.car;
          if(argNext is CLispCons) {
            argName = (argNext as CLispCons).car as CLispSymbolRaw;
          } else argName = argNext as CLispSymbolRaw;
          optional = true;
        } else if(CLispSymbolRaw.KEY.equals(argName)) {
          an = an.cdr as CLispCons;
          var keys:Vector.<CLispSymbolRaw> = extractKeys(an, bd, se, sc, scope);
          an = CLispNil.NIL;
          key = true;
          while(!CLispNil.NIL.equals(av)) {
            argNext = av.car;
            if(!(argNext is CLispSymbol))
              throw new Error("Key expected! Need: " + mArguments.toString() + " given " + args.toString());
            var keyName:String = (argNext as CLispSymbolRaw).rawName;
            if(keyName.charAt(0) != ":")
              throw new Error("Key should start with semicolon! Need: " +
                              mArguments.toString() + " given " + args.toString());
            argName = new CLispSymbolRaw(keyName.substr(1));
            var notFound:Boolean = true;
            for each(var iter:CLispSymbolRaw in keys)
              if(iter.equals(argName)) {
                notFound = false;
                break;
              }
            if(notFound) throw new Error("Key not Found! Need: " + mArguments.toString() + " given " + args.toString());
            av = av.cdr as CLispCons;
            argVal = av.car;
            bd.setBinding(argName.rawName, argVal);
            av = av.cdr as CLispCons;
          }
          break;
        }
        bd.setBinding(argName.rawName, se.execute(sc, av.car, scope));
        an = an.cdr as CLispCons;
        av = av.cdr as CLispCons;
      }
      if(!rest) {
        if(!CLispNil.NIL.equals(an)) {
          if(!optional) {
            argName = an.car as CLispSymbolRaw;
            if(CLispSymbolRaw.OPTIONAL.equals(argName)) {
              optional = true;
              an = an.cdr as CLispCons;
            } else if(CLispSymbolRaw.KEY.equals(argName)) {
              key = true;
              an = an.cdr as CLispCons;
              extractKeys(an, bd, se, sc, scope);
              an = CLispNil.NIL;
            } else throw new Error("Too few arguments. Need: " + mArguments.toString() + " given " + args.toString());
          }
          while(!CLispNil.NIL.equals(an)) {
            argNext = an.car;
            var argVal:CLispSymbol = CLispNil.NIL;
            if(argNext is CLispCons) {
              argName = (argNext as CLispCons).car as CLispSymbolRaw;
              argVal = se.execute(sc, (argNext as CLispCons).cadr, scope);
            } else argName = argNext as CLispSymbolRaw;
            bd.setBinding(argName.rawName, argVal);
            an = an.cdr as CLispCons;
          }
        }
        if(!CLispNil.NIL.equals(av))
          throw new Error("Too many arguments. Need: " + mArguments.toString() + " given " + args.toString());
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

    private function extractKeys(an:CLispCons, bd:Bindings, se:ScriptEngine,
                                 ctx:ScriptContext, scope:uint):Vector.<CLispSymbolRaw> {
      var res:Vector.<CLispSymbolRaw> = new Vector.<CLispSymbolRaw>;
      while(!CLispNil.NIL.equals(an)) {
        var argNext:CLispSymbol = an.car;
        var argVal:CLispSymbol = CLispNil.NIL;
        var argName:CLispSymbolRaw;
        if(argNext is CLispCons) {
          argName = (argNext as CLispCons).car as CLispSymbolRaw;
          argVal = se.execute(ctx, (argNext as CLispCons).cadr, scope);
        } else argName = argNext as CLispSymbolRaw;
        bd.setBinding(argName.rawName, argVal);
        res.push(argName);
        an = an.cdr as CLispCons;
      }
      return res;
    }
  }
}
