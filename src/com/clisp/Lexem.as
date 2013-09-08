package com.clisp {
  public class Lexem {
    public static const BRACE:String = "clisp.lexem.brace";
    public static const NUMBER:String = "clisp.lexem.number";
    public static const NIL:String = "clisp.lexem.nil";
    public static const STRING:String = "clisp.lexem.string";
    public static const SYMBOL:String = "clisp.lexem.symbol";
    public static const ESCAPE:String = "clisp.lexem.escape";

    private static const start:RegExp = /^\(/;
    private static const end:RegExp = /^\)/;
    private static const number:RegExp = /^\+?\-?\d+(\.\d*)?(?!\w)/;
    private static const nil:RegExp = /^nil/;
    private static const string:RegExp = /^"[^\"]*"/;
    private static const symbol:RegExp = /^[-<>=+a-zA-Z_][-<>=+\\*\w]*/;
    private static const escape:RegExp = /^\'/;
    private static const matchers:Vector.<RegExp> = Vector.<RegExp>([start, end, number, escape, nil, symbol, string]);

    public static function fetch(script:String, charId:Number = 0):Lexem {
      var matched:RegExp = null;
      var res:Object;
      for each(var reg:RegExp in matchers) {
        res = reg.exec(script.substr(charId));
        if(res){
          matched = reg;
          break;
        }
      }
      if(matched) {
        switch(matched) {
        case start: return new Lexem(BRACE, "(");
        case end: return new Lexem(BRACE, ")");
        case number: return new Lexem(NUMBER, res[0]);
        case symbol: return new Lexem(SYMBOL, res[0]);
        case escape: return new Lexem(ESCAPE, "'");
        case string: return new Lexem(STRING, res[0]);
        case nil: return new Lexem(NIL, "nil");
        }
      }
      trace("(EE) Lexem not found: " + script + ". ");
      return null;
    }

    public var type:String;
    public var value:String;

    public function Lexem(type:String, value:String) {
      this.type = type;
      this.value = value;
    }
  }
}
