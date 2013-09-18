package com.clisp {
  public class Lexem {
    public static const BRACE:String = "clisp.lexem.brace";
    public static const NUMBER:String = "clisp.lexem.number";
    public static const QUOTE:String = "clisp.lexem.quote";
    public static const SHARP_QUOTE:String = "clisp.lexem.sharp-quote";
    public static const BACKQUOTE:String = "clisp.lexem.backquote";
    public static const COMMA_AT:String = "clisp.lexem.comma-at";
    public static const COMMA:String = "clisp.lexem.comma";
    public static const NIL:String = "clisp.lexem.nil";
    public static const STRING:String = "clisp.lexem.string";
    public static const SYMBOL:String = "clisp.lexem.symbol";

    private static const start:RegExp = /^\(/;
    private static const end:RegExp = /^\)/;
    private static const number:RegExp = /^\+?\-?\d+(\.\d*)?(?!\w)/;
    private static const quote:RegExp = /^\'/;
    private static const sharp_quote:RegExp = /^#\'/;
    private static const backquote:RegExp = /^\`/;
    private static const comma_at:RegExp = /^\,\@/;
    private static const comma:RegExp = /^\,/;
    private static const nil:RegExp = /^nil/;
    private static const string:RegExp = /^"[^\"]*"/;
    private static const symbol:RegExp = /^[^()`\'\d,\s][^()\s]*/;
    private static const matchers:Vector.<RegExp> = Vector.<RegExp>([start, end, number, quote, sharp_quote, backquote,
                                                                     comma_at, comma, nil, string, symbol]);

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
        case quote: return new Lexem(QUOTE, "'");
        case sharp_quote: return new Lexem(SHARP_QUOTE, "#'");
        case backquote: return new Lexem(BACKQUOTE, "`");
        case comma_at: return new Lexem(COMMA_AT, ",@");
        case comma: return new Lexem(COMMA, ",");
        case nil: return new Lexem(NIL, "nil");
        case string: return new Lexem(STRING, res[0]);
        case symbol: return new Lexem(SYMBOL, res[0]);
        }
      }
      throw new Error("(EE) Lexem not found: " + script + ". ");
    }

    public var type:String;
    public var value:String;

    public function Lexem(type:String, value:String) {
      this.type = type;
      this.value = value;
    }
  }
}
