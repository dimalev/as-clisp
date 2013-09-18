package com.clisp {
  public class Bindings {
    protected var mBindings:Object = {};

    public function hasBinding(name:String):Boolean { return mBindings.hasOwnProperty(name.toUpperCase()); }

    public function getBinding(name:String):* {
      name = name.toUpperCase();
      if(!mBindings.hasOwnProperty(name)) {
        trace("creating symbol " + name);
        mBindings[name] = new CLispSymbolRaw(name);
      }
      return mBindings[name];
    }

    public function setBinding(name:String, value:*):void {
      mBindings[name.toUpperCase()] = value;
    }
  }
}