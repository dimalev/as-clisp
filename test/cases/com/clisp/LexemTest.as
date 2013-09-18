package cases.com.clisp {
  import org.flexunit.asserts.*;
  import flash.utils.ByteArray;

  import com.clisp.Lexem;

  [RunWith("org.flexunit.runners.Parameterized")]
  public class LexemTest {
    // [Before]
    // public function loadCardXML():void {
    // }

    public static var numberData:Array = [ ["+12", 12], ["-22", -22], ["+1.34", 1.34], ["-2.00", -2.0] ];

    [Test(description = "test fetching number lexems",
        dataProvider=numberData)]
    public function numberLexem(str:String, res:Number):void {
      var l:Lexem = Lexem.fetch(str);
      assertEquals("lexem type (" + str + ") " + l.value + ".", l.type, Lexem.NUMBER);
      assertEquals("lexem value (" + str + ") " + l.value + ".", l.value, res);
    }

    public static var symbolData:Array = [ ["dima", "dima"], ["+", "+"], ["/)", "/"], ["eq ", "eq"] ];

    [Test(description = "test fetch symbols",
        dataProvider=symbolData)]
    public function symbolLexem(str:String, res:String):void {
      var l:Lexem = Lexem.fetch(str);
      assertEquals("lexem type (" + str + ") " + l.value + ".", Lexem.SYMBOL, l.type);
      assertEquals("lexem value (" + str + ") " + l.value + ".", res, l.value);
    }

    [Test(description = "test quoted")]
    public function escapeLexem():void {
      var l:Lexem = Lexem.fetch("'lala");
      assertEquals("lexem type", Lexem.QUOTE, l.type);
    }
  }
}
