package cases.com.clisp {
  import org.flexunit.asserts.*;
  import flash.utils.ByteArray;

  import com.clisp.CLispCons;
  import com.clisp.CLispSymbol;
  import com.clisp.CLispSymbolRaw;
  import com.clisp.CLispNumber;
  import com.clisp.CLispNil;
  import com.clisp.LexicalAnalyzer;

  public class LexicalAnalyzerTest {
    // [Before]
    // public function loadCardXML():void {
    // }

    [Test(description = "test fetching number lexems")]
    public function simpleScriptTest():void {
      var la:LexicalAnalyzer = new LexicalAnalyzer;
      var res:CLispSymbol = la.parse("(+ 5 6)");
      var intendedRes:CLispCons =
      new CLispCons(new CLispSymbolRaw("+"),
          new CLispCons(new CLispNumber("5"),
              new CLispCons(new CLispNumber("6"), new CLispNil)));
      assertTrue(intendedRes.equals(res));
    }
  }
}
