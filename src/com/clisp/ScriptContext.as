package com.clisp {
  import flash.utils.describeType;

  public class ScriptContext {
    public static const GLOBAL_SCOPE:uint = 0;

    protected var mScopes:Vector.<Bindings> = new Vector.<Bindings>;
    protected var mScopeIds:Vector.<uint> = new Vector.<uint>;

    public function get scopeIds():Vector.<uint> { return mScopeIds; }

    public function getAttribute(name:String, scope:Number = NaN):* {
      if(isNaN(scope)) {
        scope = getAttributeScope(name);
        return mScopes[isNaN(scope) ? mScopeIds[0] : scope].getBinding(name);
      }
      return mScopes[scope].getBinding(name);
    }

    public function getAttributeScope(name:String):Number {
      for(var i:uint = 0; i < mScopeIds.length; ++i) {
        if(mScopes[mScopeIds[i]].hasBinding(name))
          return mScopeIds[i];
      }
      return NaN;
    }

    public function setAttribute(name:String, value:*, scope:uint):void {
      if(mScopes.length <= scope || !mScopes[scope]) setBindings(new Bindings, scope);
      mScopes[scope].setBinding(name, value);
    }

    public function getBindings(scope:uint):Bindings { return mScopes[scope]; }

    public function setBindings(bindings:Bindings, scope:uint):void {
      if(mScopes.length <= scope || null == mScopes[scope]) mScopeIds.unshift(scope);
      mScopes[scope] = bindings;
      if(null != bindings) return;
      mScopeIds.splice(mScopeIds.indexOf(scope), 1);
    }

    public function importCustom(object:Object):void {
      var b:Bindings = getBindings(GLOBAL_SCOPE);
      var td:XML = describeType(object);
      var name:String;
      var realName:String;
      for each(var v:XML in td.method) {
        var macros:XML = v.metadata.(@name == "Macros")[0];
        var method:XML = v.metadata.(@name == "Function")[0];

        if(macros) {
          name = macros.arg.(@key == "name")[0].@value;
          realName = v.@name;
          b.setBinding(name, new InternalFunction(object[realName]));
        } else if(method) {
          name = method.arg.(@key == "name")[0].@value;
          realName = v.@name;
          b.setBinding(name, new FunctionDecomposer(object[realName]));
        }
      }
    }
  }
}

import com.clisp.IFunction;
import com.clisp.ScriptEngine;
import com.clisp.ScriptContext;
import com.clisp.CLispSymbol;
import com.clisp.CLispString;
import com.clisp.CLispNumber;
import com.clisp.CLispNil;
import com.clisp.CLispCons;

class FunctionDecomposer extends CLispSymbol implements IFunction {
  private var toCall:Function;

  public function FunctionDecomposer(f:Function) {
    toCall = f;
  }

  public function execute(se:ScriptEngine, sc:ScriptContext, scope:uint, args:CLispCons):CLispSymbol {
    var realArgs:Array = [];
      while(!CLispNil.NIL.equals(args)) {
        var param:CLispSymbol = se.execute(sc, args.car, scope);
        if(param is CLispString) realArgs.push((param as CLispString).value);
        else if(param is CLispNumber) realArgs.push((param as CLispNumber).number);
        else realArgs.push(param);
        args = args.cdr as CLispCons;
      }
    var res:Object = toCall(se, sc, scope, realArgs);
    if(res is Number) return new CLispNumber(res as Number);
    if(res is String) return new CLispString(res as String);
    return CLispNil.NIL;
  }
}