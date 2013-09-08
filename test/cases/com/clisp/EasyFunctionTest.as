package cases.com.clisp {
  import org.flexunit.Assert;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;
  import com.clisp.CLispSymbol;
  import com.clisp.CLispNumber;
  import com.clisp.LexicalAnalyzer;
  import com.clisp.EasyFunction;

  public class EasyFunctionTest {
    [Test(description = "create own API")]
    public function ownAPI():void {
      var la:LexicalAnalyzer = new LexicalAnalyzer;
      var se:ScriptEngine = new ScriptEngine;
      var sc:ScriptContext = se.buildDefaultContext();
      sc.setAttribute("pow", new EasyFunction(
        function(args:Array):Number {
          var base:Number = args[0];
          var power:Number = args[1];
          return Math.pow(base, power);
        }), ScriptContext.GLOBAL_SCOPE);
      var prog:String = ["(progn",
                         "  (setq a 4)",
                         "  (setq b 3)",
                         "  (pow a b))"].join("\n");
      var res:CLispSymbol = se.execute(sc, la.parse(prog));
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 64);
    }
  }
}