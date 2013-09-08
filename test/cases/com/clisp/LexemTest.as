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
      assertEquals("lexem type", Lexem.NUMBER, l.type);
      assertEquals("lexem value", res, l.value);
    }
  }
}
