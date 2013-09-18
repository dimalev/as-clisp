package com.clisp {
  public class CLispSymbolRaw extends CLispSymbol {
    // Boolean
    public static const T:CLispSymbolRaw = new CLispSymbolRaw("t");
    // Parameters list modifiers
    public static const REST:CLispSymbolRaw = new CLispSymbolRaw("&rest");
    public static const OPTIONAL:CLispSymbolRaw = new CLispSymbolRaw("&optional");
    public static const KEY:CLispSymbolRaw = new CLispSymbolRaw("&key");
    // Special operators
    public static const LAMBDA:CLispSymbolRaw = new CLispSymbolRaw("lambda");
    public static const QUOTE:CLispSymbolRaw = new CLispSymbolRaw("quote");
    public static const APPLY:CLispSymbolRaw = new CLispSymbolRaw("apply");
    public static const BACKQUOTE:CLispSymbolRaw = new CLispSymbolRaw("backquote");
    public static const SHARP_QUOTE:CLispSymbolRaw = new CLispSymbolRaw("function");
    public static const COMMA:CLispSymbolRaw = new CLispSymbolRaw(",");
    public static const COMMA_AT:CLispSymbolRaw = new CLispSymbolRaw(",@");

    // Basic types
    public static const NULL:CLispSymbolRaw = new CLispSymbolRaw("null");
    public static const SYMBOL:CLispSymbolRaw = new CLispSymbolRaw("symbol");
    public static const CONS:CLispSymbolRaw = new CLispSymbolRaw("cons");
    public static const NUMBER:CLispSymbolRaw = new CLispSymbolRaw("number");
    public static const STRING:CLispSymbolRaw = new CLispSymbolRaw("string");

    public var rawName:String;

    public override function get type():CLispSymbolRaw { return CLispSymbolRaw.SYMBOL; }

    public function CLispSymbolRaw(rawName:String) {
      this.rawName = rawName.toUpperCase();
    }

    public override function toString():String { return rawName; }

    public override function equals(that:CLispSymbol):Boolean {
      if(!(that is CLispSymbolRaw)) return false;
      return rawName == (that as CLispSymbolRaw).rawName;
    }
  }
}