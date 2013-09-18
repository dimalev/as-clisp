package com.clisp {
  import com.clisp.operators.Quote;
  import com.clisp.operators.Backquote;

  public class LexicalAnalyzer {
    private static const EMPTY:RegExp = /^\s+/;

    // general parser. Does not know what does it parse.
    public function parse(script:String):CLispSymbol {
      var res:ParseResult = parse2(script.split("\n"));
      // if(res.charCount != script.length)
      //   trace(" (WW) Garbage in the end of script: " + res.charCount + ": " + script.substr(res.charCount));
      return res.result;
    }

    protected function parse2(prog:Array, canSpace:Boolean = true, lineId:uint = 0, charId:uint = 0):ParseResult {
      var line:String = prog[lineId].substr(charId);
      var so:Object = EMPTY.exec(line);
      var skiped:uint = 0;
      var res:ParseResult;
      if(so) {
        if(!canSpace) {
          trace("Illegal white spaces! line " + lineId + " char " + charId + ": " + line);
        }
        skiped = so[0].length;
        charId += skiped;
        line = line.substr(skiped);
      }
      if(line.length == 0) {
        res = parse2(prog, true, lineId+1, 0);
        return new ParseResult(res.result, res.lineCount+1, res.charCount);
      }
      var lexem:Lexem = Lexem.fetch(line);
      if(!lexem) {
        trace("Error on line " + lineId + " char " + charId + " : " + line);
        throw new Error("Parse error");
      } else {
        charId += lexem.value.length;
        skiped += lexem.value.length;
        line = line.substr(lexem.value.length);
        switch(lexem.type) {
        case Lexem.NUMBER: return new ParseResult(new CLispNumber(lexem.value), 0, skiped);
        case Lexem.QUOTE: return quotify(CLispSymbolRaw.QUOTE, prog, lineId, charId, skiped);
        case Lexem.SHARP_QUOTE: return quotify(CLispSymbolRaw.SHARP_QUOTE, prog, lineId, charId, skiped);
        case Lexem.BACKQUOTE: return quotify(CLispSymbolRaw.BACKQUOTE, prog, lineId, charId, skiped);
        case Lexem.COMMA: return quotify(CLispSymbolRaw.COMMA, prog, lineId, charId, skiped);
        case Lexem.COMMA_AT: return quotify(CLispSymbolRaw.COMMA_AT, prog, lineId, charId, skiped);
        case Lexem.STRING:
          return new ParseResult(new CLispString(lexem.value.substr(1, lexem.value.length - 2)), 0, skiped);
        case Lexem.SYMBOL:
          return new ParseResult(new CLispSymbolRaw(lexem.value), 0, skiped);
        case Lexem.NIL: return new ParseResult(CLispNil.NIL, 0, skiped);
        case Lexem.BRACE:
          if(lexem.value == ")") {
            trace("Error parsing - unexpected closing brace! line " + lineId + " char " + (charId-1) + " " + line);
            trace(prog.join("\n"));
            throw new Error("Parse error");
          }
          var nil:CLispCons = CLispNil.NIL;
          var current:CLispCons = null;
          var head:CLispCons = null;
          var lines:Number = 0;
          while(true) {
            while(true) {
              so = EMPTY.exec(line);
              if(so) {
                skiped += so[0].length;
                charId += so[0].length;
                line = line.substr(so[0].length);
              }
              if(line.length == 0) {
                ++lines;
                charId = 0;
                skiped = 0;
                line = prog[lineId + lines];
                continue;
              }
              break;
            }
            lexem = Lexem.fetch(line);
            if(lexem.type == Lexem.BRACE && lexem.value == ")") {
              skiped += 1;
              charId += 1;
              break;
            }
            res = parse2(prog, true, lineId + lines, charId);
            if(res.lineCount == 0) {
              charId += res.charCount;
              skiped += res.charCount;
              line = line.substr(res.charCount);
            } else {
              skiped = charId = res.charCount;
              lines += res.lineCount;
              line = prog[lineId + lines].substr(res.charCount);
            }
            var newc:CLispCons = new CLispCons(res.result, CLispNil.NIL);
            if(current) current.cdr = newc;
            else head = newc;
            current = newc;
          }
          if(head) return new ParseResult(head, lines, skiped);
          return new ParseResult(CLispNil.NIL, lines, skiped);
          break;
        }
      }
      throw new Error("Unreachable!");
    }

    private function quotify(symbol:CLispSymbolRaw, prog:Array, lineId:uint, charId:uint, skiped:uint):ParseResult {
      var res:ParseResult = parse2(prog, false, lineId, charId);
      if(res.lineCount == 0)
        return new ParseResult(new CLispCons(symbol, new CLispCons(res.result, CLispNil.NIL)),
                               0, skiped + res.charCount);
      return new ParseResult(new CLispCons(symbol, new CLispCons(res.result, CLispNil.NIL)),
                             res.lineCount, res.charCount);
    }
  }
}

import com.clisp.CLispSymbol;

class ParseResult {
  public var result:CLispSymbol;
  public var lineCount:Number;
  public var charCount:Number;

  public function ParseResult(result:CLispSymbol, lineCount:Number, charCount:Number) {
    this.result = result;
    this.lineCount = lineCount;
    this.charCount = charCount;
  }
}