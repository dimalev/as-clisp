package cases.com.clisp {
  import org.flexunit.Assert;
  import com.clisp.ScriptEngine;
  import com.clisp.CLispSymbol;
  import com.clisp.CLispNumber;
  import com.clisp.LexicalAnalyzer;

  public class ScriptEngineTest {
    [Test(description = "Running simple program")]
    public function simpleRun():void {
      var res:CLispSymbol = buildAndRun("(+ 5 6)");
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 11);
    }

    [Test(description = "Testing set operation")]
    public function checkSet():void {
      var res:CLispSymbol = buildAndRun("(progn (set 'a 10) (set 'b 12) (+ a b))");
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 22);
    }

    [Test(description = "Testing function definition")]
    public function defineAndRun():void {
      var res:CLispSymbol = buildAndRun("(progn (def inc (data) (+ data 1)) (inc 12))");
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 13);
    }

    [Test(description = "Testing function encapsulation")]
    public function defEncapsulation():void {
      var res:CLispSymbol = buildAndRun("(progn (set 'val 12) (def inc (data) (set 'val 1) (+ data val)) (inc 12) val)");
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 12);
    }

    [Test(description = "Multiline program")]
    public function multiline():void {
      var res:CLispSymbol = buildAndRun(["(progn           ",
                                         "  (set 'val 12)  ",
                                         "  (def inc (data)",
                                         "    (set 'val 1) ",
                                         "    (+ data val))",
                                         "  (inc 12)       ",
                                         "  val)           "].join("\n"));
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 12);
    }

    [Test(description = "condition check")]
    public function conditions():void {
      var res:CLispSymbol = buildAndRun(["(if           ",
                                         "  (= 12 12)  ",
                                         "  10",
                                         "  100)           "].join("\n"));
      Assert.assertTrue("We got number as a result", res is CLispNumber);
      Assert.assertTrue("Right number", (res as CLispNumber).number == 10);
    }

    private function buildAndRun(prog:String):CLispSymbol {
      var la:LexicalAnalyzer = new LexicalAnalyzer;
      var se:ScriptEngine = new ScriptEngine;
      return se.execute(se.buildDefaultContext(), la.parse(prog));
    }
  }
}