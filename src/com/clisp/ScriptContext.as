package com.clisp {
  public class ScriptContext {
    public static const GLOBAL_SCOPE:uint = 0;

    protected var mScopes:Vector.<Bindings> = new Vector.<Bindings>;
    protected var mScopeIds:Vector.<uint> = new Vector.<uint>;

    public function get scopeIds():Vector.<uint> { return mScopeIds; }

    public function getAttribute(name:String, scope:Number = NaN):* {
      if(isNaN(scope)) {
        for(var i:uint = 0; i < mScopeIds.length; ++i) {
          if(mScopes[mScopeIds[i]].hasBinding(name))
            return mScopes[mScopeIds[i]].getBinding(name);
        }
        return mScopes[mScopeIds[0]].getBinding(name);
      }
      return mScopes[scope].getBinding(name);
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
  }
}